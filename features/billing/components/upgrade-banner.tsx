import type { JSX } from 'react'
import { createCheckoutSession } from '../actions'
import { PRICE_LABEL } from '../constants'

export function UpgradeBanner(): JSX.Element {
  return (
    <div className="rounded-lg border border-accent/40 bg-surface p-8 text-center">
      <svg
        className="mx-auto mb-4 h-10 w-10 text-accent"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor"
        strokeWidth={1.5}
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"
        />
      </svg>
      <h2 className="font-heading text-2xl font-extrabold">Unlock Full Access</h2>
      <p className="mx-auto mt-2 max-w-md text-sm text-muted">
        CompTIA Security+ (SY0-701) — unlimited questions, every study mode,
        full 90-minute practice exam, and adaptive spaced repetition.
      </p>
      <form action={createCheckoutSession} className="mt-6">
        <button
          type="submit"
          className="rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
        >
          Start Studying — {PRICE_LABEL}
        </button>
      </form>
      <p className="mt-3 text-xs text-muted">7-day money-back guarantee, no questions asked</p>
    </div>
  )
}
