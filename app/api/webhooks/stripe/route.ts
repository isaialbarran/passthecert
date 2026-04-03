import { stripe } from '@/shared/lib/stripe'
import { createAdminClient } from '@/shared/lib/supabase'
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
      process.env.STRIPE_WEBHOOK_SECRET!
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
        await supabase
          .from('profiles')
          .update({
            stripe_customer_id: session.customer as string,
            subscription_status: 'active',
            subscription_tier: 'pro',
          })
          .eq('id', userId)
      }
      break
    }

    case 'customer.subscription.updated': {
      const subscription = event.data.object as Stripe.Subscription
      const customerId = subscription.customer as string

      const status = subscription.status === 'active' ? 'active' : 'past_due'
      const tier = subscription.status === 'active' ? 'pro' : 'free'

      await supabase
        .from('profiles')
        .update({
          subscription_status: status,
          subscription_tier: tier,
        })
        .eq('stripe_customer_id', customerId)
      break
    }

    case 'customer.subscription.deleted': {
      const subscription = event.data.object as Stripe.Subscription
      const customerId = subscription.customer as string

      await supabase
        .from('profiles')
        .update({
          subscription_status: 'canceled',
          subscription_tier: 'free',
        })
        .eq('stripe_customer_id', customerId)
      break
    }

    case 'invoice.payment_failed': {
      const invoice = event.data.object as Stripe.Invoice
      const customerId = invoice.customer as string

      await supabase
        .from('profiles')
        .update({ subscription_status: 'past_due' })
        .eq('stripe_customer_id', customerId)
      break
    }
  }

  return new Response('ok', { status: 200 })
}
