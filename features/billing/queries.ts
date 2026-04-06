import { createClient } from '@/shared/lib/supabase'
import type { SubscriptionStatus } from './types'

export async function isPro(userId: string): Promise<boolean> {
  const supabase = await createClient()

  const { data } = await supabase
    .from('profiles')
    .select('subscription_status')
    .eq('id', userId)
    .single()

  return data?.subscription_status === 'active'
}

export async function getSubscriptionStatus(
  userId: string
): Promise<SubscriptionStatus> {
  const supabase = await createClient()

  const { data } = await supabase
    .from('profiles')
    .select('subscription_status')
    .eq('id', userId)
    .single()

  if (!data?.subscription_status) return null

  const status = data.subscription_status as SubscriptionStatus
  return status
}

export async function getDailyQuestionCount(
  userId: string
): Promise<number> {
  const supabase = await createClient()

  const todayStart = new Date()
  todayStart.setHours(0, 0, 0, 0)

  const { count } = await supabase
    .from('user_responses')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .gte('created_at', todayStart.toISOString())

  return count ?? 0
}
