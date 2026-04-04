import { z } from 'zod'

/**
 * Server-side environment variables.
 * Validated once on first access — crashes immediately with a clear message
 * if any required variable is missing, instead of failing deep in a request.
 */
const serverSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url('NEXT_PUBLIC_SUPABASE_URL must be a valid URL'),
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY: z.string().min(1, 'NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY is required'),
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1, 'SUPABASE_SERVICE_ROLE_KEY is required'),
  STRIPE_SECRET_KEY: z.string().startsWith('sk_', 'STRIPE_SECRET_KEY must start with sk_'),
  STRIPE_WEBHOOK_SECRET: z.string().startsWith('whsec_', 'STRIPE_WEBHOOK_SECRET must start with whsec_'),
  STRIPE_PRO_PRICE_ID: z.string().startsWith('price_', 'STRIPE_PRO_PRICE_ID must start with price_'),
  RESEND_API_KEY: z.string().startsWith('re_', 'RESEND_API_KEY must start with re_'),
  NEXT_PUBLIC_APP_URL: z.string().url('NEXT_PUBLIC_APP_URL must be a valid URL'),
})

/**
 * Client-side environment variables (NEXT_PUBLIC_ only).
 * Safe to access in browser code.
 */
const clientSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY: z.string().min(1),
  NEXT_PUBLIC_APP_URL: z.string().url(),
})

export type ServerEnv = z.infer<typeof serverSchema>
export type ClientEnv = z.infer<typeof clientSchema>

let _serverEnv: ServerEnv | null = null
let _clientEnv: ClientEnv | null = null

/**
 * Validated server environment. Call from Server Components, Server Actions, or API routes only.
 * Throws a descriptive error on first call if any variable is missing or malformed.
 */
export function serverEnv(): ServerEnv {
  if (_serverEnv) return _serverEnv

  const result = serverSchema.safeParse(process.env)
  if (!result.success) {
    const missing = result.error.issues
      .map((i) => `  - ${i.path.join('.')}: ${i.message}`)
      .join('\n')
    throw new Error(`\n❌ Invalid server environment variables:\n${missing}\n\nCheck your .env.local file.\n`)
  }

  _serverEnv = result.data
  return _serverEnv
}

/**
 * Validated client environment. Safe to call anywhere.
 */
export function clientEnv(): ClientEnv {
  if (_clientEnv) return _clientEnv

  const result = clientSchema.safeParse({
    NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
    NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY: process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY,
    NEXT_PUBLIC_APP_URL: process.env.NEXT_PUBLIC_APP_URL,
  })

  if (!result.success) {
    const missing = result.error.issues
      .map((i) => `  - ${i.path.join('.')}: ${i.message}`)
      .join('\n')
    throw new Error(`\n❌ Invalid client environment variables:\n${missing}\n`)
  }

  _clientEnv = result.data
  return _clientEnv
}
