import { stripe } from '@/shared/lib/stripe'
import { createAdminClient } from '@/shared/lib/supabase'
import { serverEnv } from '@/shared/lib/env'
import type Stripe from 'stripe'

export async function POST(request: Request) {
  const body = await request.text()
  const signature = request.headers.get('stripe-signature')

  if (!signature) {
    return new Response('Missing stripe-signature header', { status: 400 })
  }

  let event: Stripe.Event

  try {
    event = stripe().webhooks.constructEvent(
      body,
      signature,
      serverEnv().STRIPE_WEBHOOK_SECRET
    )
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unknown error'
    return new Response(`Webhook signature verification failed: ${message}`, {
      status: 400,
    })
  }

  const supabase = createAdminClient()

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session
      const userId = session.metadata?.supabase_user_id

      if (userId) {
        const { error } = await supabase
          .from('profiles')
          .update({
            stripe_customer_id: session.customer as string,
            subscription_status: 'active',
            subscription_tier: 'pro',
          })
          .eq('id', userId)

        if (error) {
          return new Response('DB update failed', { status: 500 })
        }
      }
      break
    }

    case 'customer.subscription.updated': {
      const subscription = event.data.object as Stripe.Subscription
      const customerId = subscription.customer as string

      const isActive = subscription.status === 'active' || subscription.status === 'trialing'

      if (isActive) {
        const { error } = await supabase
          .from('profiles')
          .update({
            subscription_status: 'active',
            subscription_tier: 'pro',
          })
          .eq('stripe_customer_id', customerId)

        if (error) {
          return new Response('DB update failed', { status: 500 })
        }
      } else if (subscription.status === 'past_due') {
        const { error } = await supabase
          .from('profiles')
          .update({ subscription_status: 'past_due' })
          .eq('stripe_customer_id', customerId)

        if (error) {
          return new Response('DB update failed', { status: 500 })
        }
      }
      // Ignore other statuses (incomplete, incomplete_expired) to avoid
      // overwriting 'active' set by checkout.session.completed
      break
    }

    case 'customer.subscription.deleted': {
      const subscription = event.data.object as Stripe.Subscription
      const customerId = subscription.customer as string

      const { error } = await supabase
        .from('profiles')
        .update({
          subscription_status: 'canceled',
          subscription_tier: 'free',
        })
        .eq('stripe_customer_id', customerId)

      if (error) {
        return new Response('DB update failed', { status: 500 })
      }
      break
    }

    case 'invoice.payment_failed': {
      const invoice = event.data.object as Stripe.Invoice
      const customerId = invoice.customer as string

      const { error } = await supabase
        .from('profiles')
        .update({ subscription_status: 'past_due' })
        .eq('stripe_customer_id', customerId)

      if (error) {
        return new Response('DB update failed', { status: 500 })
      }
      break
    }
  }

  return new Response('ok', { status: 200 })
}
