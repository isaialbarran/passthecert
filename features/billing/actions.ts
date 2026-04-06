'use server'

import { createClient } from '@/shared/lib/supabase'
import { stripe } from '@/shared/lib/stripe'
import { serverEnv } from '@/shared/lib/env'
import { requireAuth } from '@/features/auth'
import { redirect } from 'next/navigation'
import { isPro } from './queries'

export async function createCheckoutSession(): Promise<{ url: string }> {
  const user = await requireAuth()
  const supabase = await createClient()

  const env = serverEnv()

  const { data: profile, error: profileError } = await supabase
    .from('profiles')
    .select('stripe_customer_id, email')
    .eq('id', user.id)
    .single()

  if (profileError || !profile) {
    throw new Error('Profile not found')
  }

  let customerId = profile.stripe_customer_id

  if (!customerId) {
    const customer = await stripe().customers.create({
      email: profile.email,
      metadata: { supabase_user_id: user.id },
    })
    customerId = customer.id

    const { error: updateError } = await supabase
      .from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', user.id)

    if (updateError) {
      throw new Error('Failed to save Stripe customer ID')
    }
  }

  const session = await stripe().checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    line_items: [
      {
        price: env.STRIPE_PRO_PRICE_ID,
        quantity: 1,
      },
    ],
    success_url: `${env.NEXT_PUBLIC_APP_URL}/dashboard?upgraded=true`,
    cancel_url: `${env.NEXT_PUBLIC_APP_URL}/dashboard`,
    metadata: { supabase_user_id: user.id },
  })

  if (!session.url) {
    throw new Error('Stripe did not return a checkout URL')
  }

  return { url: session.url }
}

export async function createCheckoutAndRedirect(): Promise<never> {
  const { url } = await createCheckoutSession()
  redirect(url)
}

type PortalFlow = 'payment_method_update' | 'subscription_cancel' | null

export async function createPortalSession(
  flow?: PortalFlow
): Promise<{ url: string }> {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: profile, error: profileError } = await supabase
    .from('profiles')
    .select('stripe_customer_id')
    .eq('id', user.id)
    .single()

  if (profileError || !profile?.stripe_customer_id) {
    throw new Error('No billing account found')
  }

  const env = serverEnv()

  const params: Record<string, unknown> = {
    customer: profile.stripe_customer_id,
    return_url: `${env.NEXT_PUBLIC_APP_URL}/settings`,
  }

  if (flow === 'payment_method_update') {
    params.flow_data = { type: 'payment_method_update' }
  } else if (flow === 'subscription_cancel') {
    params.flow_data = {
      type: 'subscription_cancel',
      subscription_cancel: {
        subscription: await getActiveSubscriptionId(
          profile.stripe_customer_id
        ),
      },
    }
  }

  const portalSession = await stripe().billingPortal.sessions.create(
    params as Parameters<
      ReturnType<typeof stripe>['billingPortal']['sessions']['create']
    >[0]
  )

  return { url: portalSession.url }
}

async function getActiveSubscriptionId(
  customerId: string
): Promise<string> {
  const subscriptions = await stripe().subscriptions.list({
    customer: customerId,
    status: 'active',
    limit: 1,
  })

  if (!subscriptions.data[0]) {
    throw new Error('No active subscription found')
  }

  return subscriptions.data[0].id
}

export async function createPortalAndRedirect(): Promise<never> {
  const { url } = await createPortalSession()
  redirect(url)
}

export async function updatePaymentMethodAndRedirect(): Promise<never> {
  const { url } = await createPortalSession('payment_method_update')
  redirect(url)
}

export async function cancelSubscriptionAndRedirect(): Promise<never> {
  const { url } = await createPortalSession('subscription_cancel')
  redirect(url)
}

export async function checkIsPro(): Promise<boolean> {
  const user = await requireAuth()
  return isPro(user.id)
}
