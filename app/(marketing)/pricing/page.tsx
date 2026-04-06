import { getUser } from '@/features/auth'
import { checkIsPro, createCheckoutAndRedirect, PRICE_CTA } from '@/features/billing'
import Link from 'next/link'

const FEATURES = [
  'Unlimited questions',
  'All study modes (Quick 10, Domain Focus, Review Mistakes)',
  'Full exam simulation (90 min, 90 questions)',
  'Personalized study plan based on your diagnostic',
  'Readiness score and domain tracking',
] as const

export default async function PricingPage(): Promise<React.JSX.Element> {
  const user = await getUser()
  const isProUser = user ? await checkIsPro() : false

  return (
    <main className="mx-auto max-w-lg px-4 py-24">
      <h1 className="font-heading text-center text-4xl font-extrabold md:text-5xl">
        One plan. <span className="text-accent">Full</span> access.
      </h1>
      <p className="mt-4 text-center text-muted">
        Pass your Security+ certification with unlimited practice and
        intelligent spaced repetition.
      </p>

      <div className="mt-12 rounded-lg border border-accent/50 bg-surface p-8">
        <div className="flex items-baseline justify-between">
          <h2 className="font-heading text-xl font-extrabold text-accent">
            Pro
          </h2>
          <p className="font-heading text-4xl font-extrabold">
            &euro;29<span className="text-lg text-muted">/mo</span>
          </p>
        </div>

        <ul className="mt-6 space-y-3 text-sm">
          {FEATURES.map((feature) => (
            <li
              key={feature}
              className="flex items-center gap-2 text-foreground"
            >
              <span className="text-accent">&#10003;</span> {feature}
            </li>
          ))}
        </ul>

        <PricingCta isAuthenticated={!!user} isProUser={isProUser} />

        <p className="mt-3 text-center text-xs text-muted">
          7-day money-back guarantee, no questions asked
        </p>
      </div>
    </main>
  )
}

function PricingCta({
  isAuthenticated,
  isProUser,
}: {
  isAuthenticated: boolean
  isProUser: boolean
}): React.JSX.Element {
  if (isProUser) {
    return (
      <div className="mt-8 text-center">
        <p className="text-sm font-medium text-accent">
          You already have an active subscription
        </p>
        <Link
          href="/dashboard"
          className="mt-3 inline-block text-sm text-muted underline underline-offset-4 transition-colors hover:text-foreground"
        >
          Go to dashboard
        </Link>
      </div>
    )
  }

  if (!isAuthenticated) {
    return (
      <Link
        href="/auth/login?next=/dashboard"
        className="mt-8 block rounded-lg bg-accent py-3 text-center text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
      >
        {PRICE_CTA}
      </Link>
    )
  }

  return (
    <form action={createCheckoutAndRedirect}>
      <button
        type="submit"
        className="mt-8 w-full cursor-pointer rounded-lg bg-accent py-3 text-center text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
      >
        {PRICE_CTA}
      </button>
    </form>
  )
}
