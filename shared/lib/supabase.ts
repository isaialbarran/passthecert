import { createBrowserClient as createBrowser } from '@supabase/ssr'
import { createServerClient as createServer } from '@supabase/ssr'
import { cookies } from 'next/headers'

/**
 * Admin client using service role key — bypasses RLS.
 * Use only in Server Actions / API routes for operations that require elevated access.
 */
export function createAdminClient() {
  return createServer(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    {
      cookies: {
        getAll: () => [],
        setAll: () => {},
      },
    }
  )
}

export function createBrowserClient() {
  return createBrowser(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY!
  )
}

export async function createClient() {
  const cookieStore = await cookies()

  return createServer(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY!,
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
