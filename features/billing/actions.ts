'use server'

import { createClient } from '@/shared/lib/supabase'
import { stripe } from '@/shared/lib/stripe'
import { requireAuth } from '@/features/auth'
import { redirect } from 'next/navigation'

export async function createCheckoutSession() {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: profile } = await supabase
    .from('profiles')
    .select('stripe_customer_id, email')
    .eq('id', user.id)
    .single()

  if (!profile) throw new Error('Profile not found')

  let customerId = profile.stripe_customer_id

  if (!customerId) {
    const customer = await stripe().customers.create({
      email: profile.email,
      metadata: { supabase_user_id: user.id },
    })
    customerId = customer.id

    await supabase
      .from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', user.id)
  }

  const session = await stripe().checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    line_items: [
      {
        price: process.env.STRIPE_PRO_PRICE_ID!,
        quantity: 1,
      },
    ],
    success_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard?upgraded=true`,
    cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard`,
    metadata: { supabase_user_id: user.id },
  })

  if (session.url) {
    redirect(session.url)
  }
}
