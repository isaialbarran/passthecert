import { stripe } from '@/shared/lib/stripe'
import { createAdminClient } from '@/shared/lib/supabase'
import { serverEnv } from '@/shared/lib/env'
import { captureServerEvent } from '@/shared/lib/posthog-server'
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
        // Only persist the customer link here. Subscription status (and trial
        // end) are set by customer.subscription.created / .updated so we don't
        // overwrite a 'trialing' status with 'active'.
        const { error } = await supabase
          .from('profiles')
          .update({
            stripe_customer_id: session.customer as string,
          })
          .eq('id', userId)

        if (error) {
          return new Response('DB update failed', { status: 500 })
        }

        await captureServerEvent({
          distinctId: userId,
          event: 'checkout_completed',
          properties: { stripe_session_id: session.id },
        })
      }
      break
    }

    case 'customer.subscription.created':
    case 'customer.subscription.updated': {
      const subscription = event.data.object as Stripe.Subscription
      const customerId = subscription.customer as string
      const metadataUserId =
        typeof subscription.metadata?.supabase_user_id === 'string'
          ? subscription.metadata.supabase_user_id
          : null

      const trialEndsAt =
        subscription.trial_end != null
          ? new Date(subscription.trial_end * 1000).toISOString()
          : null

      const updates: Record<string, unknown> = {
        trial_ends_at: trialEndsAt,
      }

      switch (subscription.status) {
        case 'trialing':
        case 'active':
          updates.subscription_status = subscription.status
          updates.subscription_tier = 'pro'
          break
        case 'past_due':
        case 'unpaid':
        case 'canceled':
        case 'incomplete_expired':
          updates.subscription_status =
            subscription.status === 'incomplete_expired'
              ? 'canceled'
              : subscription.status
          // Keep tier='pro' so history is preserved; isPro() gates on status.
          break
        default:
          // incomplete / paused / other transient states — do not overwrite
          // status/tier, but still persist trial_ends_at so the banner is
          // accurate if a trial is already in flight.
          break
      }

      // Match by stripe_customer_id first. If that affects 0 rows (e.g.
      // subscription.created arrived before checkout.session.completed had a
      // chance to write stripe_customer_id), fall back to the supabase user id
      // carried in subscription.metadata and backfill stripe_customer_id.
      const { data: updatedByCustomer, error: customerErr } = await supabase
        .from('profiles')
        .update(updates)
        .eq('stripe_customer_id', customerId)
        .select('id')

      if (customerErr) {
        return new Response('DB update failed', { status: 500 })
      }

      if ((updatedByCustomer?.length ?? 0) === 0 && metadataUserId) {
        const { error: fallbackErr } = await supabase
          .from('profiles')
          .update({ ...updates, stripe_customer_id: customerId })
          .eq('id', metadataUserId)

        if (fallbackErr) {
          return new Response('DB update failed', { status: 500 })
        }
      }
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
          trial_ends_at: null,
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
