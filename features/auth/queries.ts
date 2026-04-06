import { cache } from 'react'
import { createClient } from '@/shared/lib/supabase'
import { redirect } from 'next/navigation'

export const getUser = cache(async () => {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()
  return user
})

export async function requireAuth(next?: string) {
  const user = await getUser()
  if (!user) {
    const loginUrl = next ? `/auth/login?next=${encodeURIComponent(next)}` : '/auth/login'
    redirect(loginUrl)
  }
  return user
}

export const getProfile = cache(async (userId: string) => {
  const supabase = await createClient()
  const { data } = await supabase
    .from('profiles')
    .select('full_name, email')
    .eq('id', userId)
    .single()
  return data
})
