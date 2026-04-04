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

export async function requireAuth() {
  const user = await getUser()
  if (!user) {
    redirect('/auth/login')
  }
  return user
}
