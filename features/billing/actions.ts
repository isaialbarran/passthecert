'use server'

import { z } from 'zod'
import { createClient } from '@/shared/lib/supabase'
import { stripe } from '@/shared/lib/stripe'
import { serverEnv } from '@/shared/lib/env'
import { requireAuth } from '@/features/auth'
import { redirect } from 'next/navigation'
import { isPro } from './queries'

const checkoutSchema = z.object({
  priceId: z.string().startsWith('price_', 'Invalid price ID'),
})

export async function createCheckoutSession(
  priceId?: string
): Promise<{ url: string }> {
  const user = await requireAuth()
  const supabase = await createClient()

  const env = serverEnv()
  const validatedPriceId = checkoutSchema.parse({
    priceId: priceId ?? env.STRIPE_PRO_PRICE_ID,
  }).priceId

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
        price: validatedPriceId,
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

export async function createPortalSession(): Promise<{ url: string }> {
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
  const portalSession = await stripe().billingPortal.sessions.create({
    customer: profile.stripe_customer_id,
    return_url: `${env.NEXT_PUBLIC_APP_URL}/dashboard`,
  })

  return { url: portalSession.url }
}

export async function createPortalAndRedirect(): Promise<never> {
  const { url } = await createPortalSession()
  redirect(url)
}

export async function checkIsPro(): Promise<boolean> {
  const user = await requireAuth()
  return isPro(user.id)
}
