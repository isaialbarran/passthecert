import Stripe from 'stripe'
import { serverEnv } from './env'

let _stripe: Stripe | null = null

export function stripe(): Stripe {
  if (!_stripe) {
    _stripe = new Stripe(serverEnv().STRIPE_SECRET_KEY, {
      typescript: true,
    })
  }
  return _stripe
}
