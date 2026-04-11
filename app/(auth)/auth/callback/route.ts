import { NextResponse } from 'next/server'
import { createClient, createAdminClient } from '@/shared/lib/supabase'

export async function GET(request: Request): Promise<NextResponse> {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')
  const type = searchParams.get('type')
  const nextParam = searchParams.get('next') ?? '/dashboard'
  const next = nextParam.startsWith('/') && !nextParam.startsWith('//') ? nextParam : '/dashboard'

  if (code) {
    const supabase = await createClient()
    const { data, error } = await supabase.auth.exchangeCodeForSession(code)

    if (!error) {
      const email = data.user?.email
      if (email) {
        const admin = createAdminClient()
        await admin
          .from('diagnostic_leads')
          .update({ converted_at: new Date().toISOString() })
          .eq('email', email)
          .is('converted_at', null)
      }

      const destination = type === 'recovery' ? '/auth/reset-password' : next
      return NextResponse.redirect(new URL(destination, origin))
    }
  }

  return NextResponse.redirect(new URL('/auth/login', origin))
}
