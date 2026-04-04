import { createBrowserClient as createBrowser } from '@supabase/ssr'
import { createServerClient as createServer } from '@supabase/ssr'
import { cookies } from 'next/headers'
import { serverEnv, clientEnv } from './env'

/**
 * Admin client using service role key — bypasses RLS.
 * Use only in Server Actions / API routes for operations that require elevated access.
 */
export function createAdminClient() {
  const env = serverEnv()

  return createServer(env.NEXT_PUBLIC_SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    cookies: {
      getAll: () => [],
      setAll: () => {},
    },
  })
}

export function createBrowserClient() {
  const env = clientEnv()
  return createBrowser(env.NEXT_PUBLIC_SUPABASE_URL, env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY)
}

export async function createClient() {
  const env = serverEnv()
  const cookieStore = await cookies()

  return createServer(
    env.NEXT_PUBLIC_SUPABASE_URL,
    env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll()
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) =>
              cookieStore.set(name, value, options)
            )
          } catch {
            // setAll is called from Server Components where cookies can't be set.
            // This can be ignored if proxy refreshes the session.
          }
        },
      },
    }
  )
}
