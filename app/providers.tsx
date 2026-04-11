'use client'

import posthog from 'posthog-js'
import { PostHogProvider, usePostHog } from 'posthog-js/react'
import { useEffect, Suspense } from 'react'
import { usePathname, useSearchParams } from 'next/navigation'
import type { AuthChangeEvent, Session, User } from '@supabase/supabase-js'
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

    // Identify users already authenticated on first load (INITIAL_SESSION does not
    // fire a SIGNED_IN event in newer Supabase versions)
    supabase.auth.getUser().then(({ data }: { data: { user: User | null } }) => {
      if (data.user) {
        ph.identify(data.user.id, { email: data.user.email })
        if (data.user.email) ph.alias(data.user.email)
      }
    })

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event: AuthChangeEvent, session: Session | null) => {
      if (event === 'SIGNED_IN' && session?.user) {
        ph.identify(session.user.id, { email: session.user.email })
        // Link the email distinctId (used by the anonymous diagnostic funnel)
        // to the Supabase userId so PostHog can connect pre-signup events
        if (session.user.email) ph.alias(session.user.email)
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
