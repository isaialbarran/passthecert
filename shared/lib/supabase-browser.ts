import { createBrowserClient as createBrowser } from '@supabase/ssr'

export function createBrowserClient(): ReturnType<typeof createBrowser> {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const key = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY
  if (!url || !key) {
    throw new Error('Missing Supabase environment variables: NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY are required')
  }
  return createBrowser(url, key)
}
