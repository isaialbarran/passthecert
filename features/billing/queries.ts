import { createClient } from '@/shared/lib/supabase'
import type { SubscriptionStatus } from './types'

const VALID_STATUSES = new Set<string>([
  'active',
  'canceled',
  'past_due',
  'unpaid',
  'trialing',
])

export async function isPro(userId: string): Promise<boolean> {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('profiles')
    .select('subscription_tier, subscription_status')
    .eq('id', userId)
    .single()

  if (error) {
    throw new Error(`Failed to check subscription: ${error.message}`)
  }

  return (
    data?.subscription_tier === 'pro' &&
    (data?.subscription_status === 'active' ||
      data?.subscription_status === 'trialing')
  )
}

export interface TrialInfo {
  endsAt: string
  daysLeft: number
}

export async function getTrialInfo(userId: string): Promise<TrialInfo | null> {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('profiles')
    .select('subscription_status, trial_ends_at')
    .eq('id', userId)
    .single()

  if (error) {
    throw new Error(`Failed to fetch trial info: ${error.message}`)
  }

  return deriveTrialInfo(data?.subscription_status, data?.trial_ends_at)
}

export interface BillingSummary {
  isPro: boolean
  trialInfo: TrialInfo | null
}

export async function getBillingSummary(
  userId: string,
): Promise<BillingSummary> {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('profiles')
    .select('subscription_tier, subscription_status, trial_ends_at')
    .eq('id', userId)
    .single()

  if (error) {
    throw new Error(`Failed to fetch billing summary: ${error.message}`)
  }

  const isPro =
    data?.subscription_tier === 'pro' &&
    (data?.subscription_status === 'active' ||
      data?.subscription_status === 'trialing')

  return {
    isPro,
    trialInfo: deriveTrialInfo(data?.subscription_status, data?.trial_ends_at),
  }
}

function deriveTrialInfo(
  status: string | null | undefined,
  trialEndsAt: string | null | undefined,
): TrialInfo | null {
  if (status !== 'trialing' || !trialEndsAt) return null

  const endMs = new Date(trialEndsAt).getTime()
  if (Number.isNaN(endMs)) return null

  const daysLeft = Math.max(
    0,
    Math.ceil((endMs - Date.now()) / (1000 * 60 * 60 * 24)),
  )

  return { endsAt: trialEndsAt, daysLeft }
}

export async function getSubscriptionStatus(
  userId: string
): Promise<SubscriptionStatus> {
  const supabase = await createClient()

  const { data, error } = await supabase
    .from('profiles')
    .select('subscription_status')
    .eq('id', userId)
    .single()

  if (error) {
    throw new Error(`Failed to fetch subscription status: ${error.message}`)
  }

  if (!data?.subscription_status) return null

  if (!VALID_STATUSES.has(data.subscription_status)) return null

  return data.subscription_status as SubscriptionStatus
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
