import { createBrowserClient as createBrowser } from '@supabase/ssr'

export function createBrowserClient(): ReturnType<typeof createBrowser> {
  return createBrowser(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY!
  )
}
