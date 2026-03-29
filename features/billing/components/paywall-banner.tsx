import { createCheckoutSession } from '@/features/billing/actions'

const features = [
  'Unlimited practice questions',
  'All quiz modes (random, full exam, domain focus, review mistakes)',
  'Spaced repetition with SM-2 algorithm',
  'Personalized study plan',
  'Readiness score & domain mastery tracking',
]

export function PaywallBanner(): React.JSX.Element {
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-[#060b06]/80 backdrop-blur-sm">
      <div className="mx-4 w-full max-w-md rounded-xl border border-[rgba(74,222,128,0.2)] bg-[#0c140c] p-8 shadow-2xl">
        <div className="text-center">
          <h2 className="font-heading text-2xl font-extrabold text-[#edfded]">
            Unlock Full Access
          </h2>
          <p className="mt-2 text-sm text-[#7ba87b]">
            Get everything you need to pass your certification exam
          </p>
        </div>

        <ul className="mt-6 space-y-3">
          {features.map((feature) => (
            <li key={feature} className="flex items-start gap-3 text-sm text-[#edfded]">
              <svg
                className="mt-0.5 h-4 w-4 shrink-0 text-[#4ade80]"
                fill="none"
                viewBox="0 0 24 24"
                strokeWidth={2.5}
                stroke="currentColor"
              >
                <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
              </svg>
              {feature}
            </li>
          ))}
        </ul>

        <div className="mt-8">
          <form action={createCheckoutSession}>
            <button
              type="submit"
              className="w-full rounded-lg bg-[#4ade80] px-4 py-3 text-sm font-medium text-[#060b06] transition-colors hover:bg-[#4ade80]/90"
            >
              Subscribe Now — €29/mo
            </button>
          </form>
          <p className="mt-3 text-center text-xs text-[#7ba87b]">
            7-day money-back guarantee, no questions asked
          </p>
        </div>
      </div>
    </div>
  )
}
