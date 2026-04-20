import type { JSX } from 'react'

interface TrialBannerProps {
  daysLeft: number
}

export function TrialBanner({ daysLeft }: TrialBannerProps): JSX.Element {
  const safeDays = Math.max(0, Math.floor(daysLeft))

  const label =
    safeDays === 0
      ? 'Free trial ends today.'
      : safeDays === 1
        ? 'Free trial — 1 day left.'
        : `Free trial — ${safeDays} days left.`

  return (
    <div className="flex flex-wrap items-center justify-between gap-3 rounded-lg border border-accent/30 bg-surface px-4 py-3 text-sm">
      <p className="text-foreground">
        <span className="font-medium text-accent">{label}</span>{' '}
        <span className="text-muted">Cancel anytime from Settings.</span>
      </p>
      <a
        href="/settings"
        className="text-xs text-muted underline underline-offset-4 transition-colors hover:text-foreground"
      >
        Manage
      </a>
    </div>
  )
}
