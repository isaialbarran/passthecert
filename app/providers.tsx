'use client'

import posthog from 'posthog-js'
import { PostHogProvider, usePostHog } from 'posthog-js/react'
import { useEffect, Suspense } from 'react'
import { usePathname, useSearchParams } from 'next/navigation'
import type { AuthChangeEvent, Session } from '@supabase/supabase-js'
import { createBrowserClient } from '@/shared/lib/supabase-browser'

if (typeof window !== 'undefined') {
  posthog.init(process.env.NEXT_PUBLIC_POSTHOG_KEY ?? '', {
    api_host: process.env.NEXT_PUBLIC_POSTHOG_HOST ?? 'https://eu.posthog.com',
    person_profiles: 'identified_only',
    capture_pageview: false, // captured manually below
    loaded: (ph) => {
      if (!process.env.NEXT_PUBLIC_POSTHOG_KEY) ph.opt_out_capturing()
    },
  })
}

function PageView(): null {
  const pathname = usePathname()
  const searchParams = useSearchParams()
  const ph = usePostHog()

  useEffect(() => {
    const search = searchParams?.toString()
    const url = window.origin + pathname + (search ? `?${search}` : '')
    ph.capture('$pageview', { $current_url: url })
  }, [pathname, searchParams, ph])

  return null
}

function AuthSync(): null {
  const ph = usePostHog()

  useEffect(() => {
    const supabase = createBrowserClient()
    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event: AuthChangeEvent, session: Session | null) => {
      if (event === 'SIGNED_IN' && session?.user) {
        ph.identify(session.user.id, { email: session.user.email })
      } else if (event === 'SIGNED_OUT') {
        ph.reset()
      }
    })
    return () => subscription.unsubscribe()
  }, [ph])

  return null
}

export function Providers({ children }: { children: React.ReactNode }): React.JSX.Element {
  return (
    <PostHogProvider client={posthog}>
      <Suspense>
        <PageView />
      </Suspense>
      <AuthSync />
      {children}
    </PostHogProvider>
  )
}
