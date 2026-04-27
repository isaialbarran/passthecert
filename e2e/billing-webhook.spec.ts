import { test, expect, request as pwRequest } from '@playwright/test'
import { createClient } from '@supabase/supabase-js'
import Stripe from 'stripe'

/**
 * BILL-03 — Webhook integration test (signed payload, no stripe-cli).
 *
 * Signs a `customer.subscription.created` event with STRIPE_WEBHOOK_SECRET
 * (Stripe SDK helper) and POSTs it to /api/webhooks/stripe. Then polls the
 * profiles row until the handler flips subscription_status/tier.
 *
 * Why not stripe-cli? `stripe trigger` requires a separate `stripe listen`
 * process and a different webhook secret per session — flaky and
 * non-automatable in CI. Signing in code uses the same secret the dev server
 * already validates, so the test is self-contained.
 */

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
const WEBHOOK_SECRET = process.env.STRIPE_WEBHOOK_SECRET
const TEST_USER_EMAIL = process.env.TEST_USER_EMAIL

const hasWebhookEnv =
  !!SUPABASE_URL && !!SERVICE_ROLE_KEY && !!WEBHOOK_SECRET && !!TEST_USER_EMAIL

interface ProfileSnapshot {
  id: string
  subscription_status: string | null
  subscription_tier: 'free' | 'pro'
  stripe_customer_id: string | null
  trial_ends_at: string | null
}

function adminSupabase() {
  return createClient(SUPABASE_URL!, SERVICE_ROLE_KEY!, {
    auth: { autoRefreshToken: false, persistSession: false },
  })
}

async function getProfile(email: string): Promise<ProfileSnapshot> {
  const { data, error } = await adminSupabase()
    .from('profiles')
    .select(
      'id, subscription_status, subscription_tier, stripe_customer_id, trial_ends_at'
    )
    .eq('email', email)
    .single()

  if (error || !data) {
    throw new Error(
      `Could not load profile for ${email}: ${error?.message ?? 'not found'}`
    )
  }
  return data as ProfileSnapshot
}

async function resetProfile(userId: string): Promise<void> {
  const { error } = await adminSupabase()
    .from('profiles')
    .update({
      subscription_status: null,
      subscription_tier: 'free',
      stripe_customer_id: null,
      trial_ends_at: null,
    })
    .eq('id', userId)
  if (error) throw new Error(`reset failed: ${error.message}`)
}

async function pollProfile(
  userId: string,
  predicate: (p: ProfileSnapshot) => boolean,
  timeoutMs = 10_000
): Promise<ProfileSnapshot> {
  const deadline = Date.now() + timeoutMs
  let last: ProfileSnapshot | null = null
  while (Date.now() < deadline) {
    const { data, error } = await adminSupabase()
      .from('profiles')
      .select(
        'id, subscription_status, subscription_tier, stripe_customer_id, trial_ends_at'
      )
      .eq('id', userId)
      .single()
    if (error) throw new Error(`poll failed: ${error.message}`)
    last = data as ProfileSnapshot
    if (predicate(last)) return last
    await new Promise((r) => setTimeout(r, 250))
  }
  throw new Error(
    `pollProfile timed out after ${timeoutMs}ms. Last snapshot: ${JSON.stringify(last)}`
  )
}

interface BuildEventArgs {
  type:
    | 'customer.subscription.created'
    | 'customer.subscription.updated'
    | 'customer.subscription.deleted'
    | 'invoice.payment_failed'
  userId: string
  customerId: string
  status?: Stripe.Subscription.Status
  trialEnd?: number | null
}

function buildEventPayload(args: BuildEventArgs): string {
  const now = Math.floor(Date.now() / 1000)
  const base = {
    id: `evt_test_${Math.random().toString(36).slice(2, 10)}`,
    object: 'event' as const,
    api_version: '2024-09-30',
    created: now,
    livemode: false,
    type: args.type,
  }

  if (args.type === 'invoice.payment_failed') {
    return JSON.stringify({
      ...base,
      data: {
        object: {
          id: `in_test_${Math.random().toString(36).slice(2, 10)}`,
          object: 'invoice',
          customer: args.customerId,
          status: 'open',
        },
      },
    })
  }

  return JSON.stringify({
    ...base,
    data: {
      object: {
        id: `sub_test_${Math.random().toString(36).slice(2, 10)}`,
        object: 'subscription',
        customer: args.customerId,
        status: args.status ?? 'active',
        metadata: { supabase_user_id: args.userId },
        trial_end: args.trialEnd ?? null,
        items: { object: 'list', data: [] },
        current_period_start: now,
        current_period_end: now + 30 * 24 * 60 * 60,
      },
    },
  })
}

async function postSignedWebhook(payload: string): Promise<{
  status: number
  body: string
}> {
  const stripeSdk = new Stripe('sk_test_dummy_for_signing_only', {
    typescript: true,
  })
  const signature = stripeSdk.webhooks.generateTestHeaderString({
    payload,
    secret: WEBHOOK_SECRET!,
  })

  const ctx = await pwRequest.newContext()
  const res = await ctx.post('http://localhost:3000/api/webhooks/stripe', {
    headers: {
      'stripe-signature': signature,
      'content-type': 'application/json',
    },
    data: payload,
  })
  const body = await res.text()
  await ctx.dispose()
  return { status: res.status(), body }
}

test.describe('BILL-03 — Stripe webhook handler (signed events)', () => {
  test.skip(
    !hasWebhookEnv,
    'NEXT_PUBLIC_SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY / STRIPE_WEBHOOK_SECRET / TEST_USER_EMAIL must be set'
  )

  test('customer.subscription.created with status=active flips profile to active+pro', async () => {
    const profile = await getProfile(TEST_USER_EMAIL!)
    await resetProfile(profile.id)

    const customerId = `cus_test_${Math.random().toString(36).slice(2, 10)}`
    const payload = buildEventPayload({
      type: 'customer.subscription.created',
      userId: profile.id,
      customerId,
      status: 'active',
    })

    const { status, body } = await postSignedWebhook(payload)
    expect(status, `webhook responded ${status}: ${body}`).toBe(200)

    const updated = await pollProfile(
      profile.id,
      (p) => p.subscription_status === 'active'
    )
    expect(updated.subscription_status).toBe('active')
    expect(updated.subscription_tier).toBe('pro')
    expect(updated.stripe_customer_id).toBe(customerId)

    await resetProfile(profile.id)
  })

  test('customer.subscription.created with status=trialing sets trial_ends_at and tier=pro', async () => {
    const profile = await getProfile(TEST_USER_EMAIL!)
    await resetProfile(profile.id)

    const customerId = `cus_test_${Math.random().toString(36).slice(2, 10)}`
    const trialEnd = Math.floor(Date.now() / 1000) + 7 * 24 * 60 * 60
    const payload = buildEventPayload({
      type: 'customer.subscription.created',
      userId: profile.id,
      customerId,
      status: 'trialing',
      trialEnd,
    })

    const { status, body } = await postSignedWebhook(payload)
    expect(status, `webhook responded ${status}: ${body}`).toBe(200)

    const updated = await pollProfile(
      profile.id,
      (p) => p.subscription_status === 'trialing'
    )
    expect(updated.subscription_tier).toBe('pro')
    expect(updated.trial_ends_at).not.toBeNull()
    // ±60s tolerance — handler converts seconds to ISO milliseconds
    const persistedSec = Math.floor(
      new Date(updated.trial_ends_at!).getTime() / 1000
    )
    expect(Math.abs(persistedSec - trialEnd)).toBeLessThan(60)

    await resetProfile(profile.id)
  })

  test('customer.subscription.deleted reverts to canceled+free', async () => {
    const profile = await getProfile(TEST_USER_EMAIL!)
    const customerId = `cus_test_${Math.random().toString(36).slice(2, 10)}`

    // Seed the row as if a prior subscription is in flight.
    await adminSupabase()
      .from('profiles')
      .update({
        subscription_status: 'active',
        subscription_tier: 'pro',
        stripe_customer_id: customerId,
        trial_ends_at: null,
      })
      .eq('id', profile.id)

    const payload = buildEventPayload({
      type: 'customer.subscription.deleted',
      userId: profile.id,
      customerId,
      status: 'canceled',
    })

    const { status, body } = await postSignedWebhook(payload)
    expect(status, `webhook responded ${status}: ${body}`).toBe(200)

    const updated = await pollProfile(
      profile.id,
      (p) => p.subscription_status === 'canceled'
    )
    expect(updated.subscription_tier).toBe('free')

    await resetProfile(profile.id)
  })

  test('invoice.payment_failed sets subscription_status=past_due', async () => {
    const profile = await getProfile(TEST_USER_EMAIL!)
    const customerId = `cus_test_${Math.random().toString(36).slice(2, 10)}`

    await adminSupabase()
      .from('profiles')
      .update({
        subscription_status: 'active',
        subscription_tier: 'pro',
        stripe_customer_id: customerId,
        trial_ends_at: null,
      })
      .eq('id', profile.id)

    const payload = buildEventPayload({
      type: 'invoice.payment_failed',
      userId: profile.id,
      customerId,
    })

    const { status, body } = await postSignedWebhook(payload)
    expect(status, `webhook responded ${status}: ${body}`).toBe(200)

    const updated = await pollProfile(
      profile.id,
      (p) => p.subscription_status === 'past_due'
    )
    expect(updated.subscription_status).toBe('past_due')

    await resetProfile(profile.id)
  })
})
