'use client'

import type { DiagnosticResult } from '../types'
// Direct imports required: this is a 'use client' component — importing from
// the barrel @/features/billing would pull in server-only query modules that
// use next/headers. Server action modules ('use server') are safe as they
// become RPC stubs on the client.
import { createCheckoutAndRedirect } from '@/features/billing/actions'
import { PRICE_LABEL, TRIAL_DAYS } from '@/features/billing/constants'

interface DiagnosticResultsProps {
  result: DiagnosticResult
  isLoggedIn: boolean
}

const PASSING_ZONE = 75

function scoreColor(percentage: number): string {
  if (percentage >= 80) return 'text-accent'
  if (percentage >= 60) return 'text-yellow-400'
  return 'text-danger'
}

function barColor(percentage: number): string {
  if (percentage >= 80) return 'bg-accent'
  if (percentage >= 60) return 'bg-yellow-400'
  return 'bg-danger'
}

// Probability of passing today based on current readiness score.
// Piecewise linear anchored at: (40, 18%), (75, 65%), (90, 90%).
// Below 20 floors at 5%; at/above 95 caps at 95%.
function passProbabilityToday(score: number): number {
  if (score <= 20) return 5
  if (score >= 95) return 95
  // 3-segment piecewise anchored at (20,5) (40,18) (75,65) (95,95):
  //   20–40: slope 0.65, intercept -8
  //   40–75: slope ≈1.343, intercept ≈-35.7
  //   75–95: slope 1.5, intercept -47.5
  const p =
    score <= 40
      ? 0.65 * score - 8
      : score <= 75
        ? 1.343 * score - 35.7
        : 1.5 * score - 47.5
  return Math.max(5, Math.min(95, Math.round(p)))
}

// Estimated hours of focused practice to reach the passing zone.
// Assumes ~1.2h per readiness point gained with spaced repetition.
function hoursToReady(score: number): number {
  const gap = Math.max(0, PASSING_ZONE - score)
  return Math.round(gap * 1.2)
}

interface PhasePlan {
  rangeLabel: string
  body: React.ReactNode
}

// Builds a phase plan scaled to the number of weeks the user actually needs.
// Keeps the three-act structure (weakest domain → rotation → full exams)
// but compresses or expands ranges instead of always showing "Weeks 1-2 / 3-4 / 5-6".
function buildPhasePlan(weeks: number, weakestDomain: string): PhasePlan[] {
  const weakestNode = <span className="text-danger">{weakestDomain}</span>

  if (weeks <= 1) {
    return [
      {
        rangeLabel: 'Days 1–3',
        body: <>Drill your weakest domain — {weakestNode}.</>,
      },
      {
        rangeLabel: 'Days 4–5',
        body: <>Review mistakes across all domains. SM-2 resurfaces what you keep forgetting.</>,
      },
      {
        rangeLabel: 'Days 6–7',
        body: <>Two full 90-question timed exams. Lock in the passing zone.</>,
      },
    ]
  }

  if (weeks === 2) {
    return [
      {
        rangeLabel: 'Week 1',
        body: <>Hammer your weakest domain — {weakestNode} — plus daily SM-2 reviews.</>,
      },
      {
        rangeLabel: 'Week 2',
        body: <>Rotate through remaining domains + full-length exams until you cross 80.</>,
      },
    ]
  }

  if (weeks === 3) {
    return [
      { rangeLabel: 'Week 1', body: <>Focus on {weakestNode}. Nothing else.</> },
      {
        rangeLabel: 'Week 2',
        body: <>Rotate through the other four domains. SM-2 surfaces what you keep forgetting.</>,
      },
      {
        rangeLabel: 'Week 3',
        body: <>Full 90-question timed exams until your readiness score crosses 80.</>,
      },
    ]
  }

  // 4+ weeks: split proportionally — ~35% weakest, ~40% rotation, ~25% exams.
  const phase1End = Math.max(1, Math.round(weeks * 0.35))
  const phase2End = Math.max(phase1End + 1, Math.round(weeks * 0.75))
  const phase3Start = phase2End + 1

  const fmt = (start: number, end: number): string =>
    start === end ? `Week ${start}` : `Weeks ${start}–${end}`

  return [
    {
      rangeLabel: fmt(1, phase1End),
      body: <>Hammer your weakest domain — {weakestNode}.</>,
    },
    {
      rangeLabel: fmt(phase1End + 1, phase2End),
      body: <>Rotate through the remaining domains. SM-2 surfaces exactly what you keep forgetting.</>,
    },
    {
      rangeLabel: fmt(phase3Start, weeks),
      body: <>Full 90-question timed exams until your readiness score crosses 80.</>,
    },
  ]
}

export function DiagnosticResults({
  result,
  isLoggedIn,
}: DiagnosticResultsProps) {
  const readiness = result.overallScore
  const passProb = passProbabilityToday(readiness)
  const hoursNeeded = hoursToReady(readiness)
  const weeks = Math.max(1, Math.ceil(hoursNeeded / 7)) // ~1h/day × 7 days per week, matches UI copy
  const isInPassingZone = readiness >= PASSING_ZONE
  // Fallback prevents rendering an empty <span> if the result was computed
  // without any answered questions (e.g. edge-case state in the client flow).
  const weakestDomainName = result.weakestDomainName || 'your weakest domain'

  return (
    <div className="space-y-8">
      {/* Readiness Score hero — one anchor number, no redundant copy */}
      <div className="text-center">
        <p className="text-sm uppercase tracking-wider text-muted">
          Your Readiness Score
        </p>
        <p
          className={`font-heading text-7xl font-extrabold ${scoreColor(readiness)}`}
        >
          {readiness}
          <span className="text-3xl text-muted">/100</span>
        </p>
        <p className="mt-2 text-xs text-muted">
          {result.correctCount} of {result.totalQuestions} correct
        </p>

        {/* Progress bar with passing zone marker.
            Inline styles are an intentional exception to the Tailwind-only rule:
            width and left are dynamic numeric values that can't be expressed
            as static utility classes. */}
        <div
          className="relative mx-auto mt-4 h-3 w-full max-w-md overflow-hidden rounded-full bg-background"
          role="progressbar"
          aria-valuenow={readiness}
          aria-valuemin={0}
          aria-valuemax={100}
          aria-label={`Readiness ${readiness} out of 100, passing zone starts at ${PASSING_ZONE}`}
        >
          <div
            className={`h-full rounded-full transition-all duration-700 ${barColor(readiness)}`}
            style={{ width: `${readiness}%` }}
          />
          <div
            role="presentation"
            className="absolute top-0 h-full w-0.5 bg-accent/60"
            style={{ left: `${PASSING_ZONE}%` }}
          />
        </div>
        <p className="mt-2 text-xs text-muted">
          Passing zone starts at {PASSING_ZONE}
        </p>
      </div>

      {/* Unified stat card: pass probability is the lead, hours is the context.
          The header + big percentage are constant; only the sub-copy branches
          on whether the user is already in the passing zone. */}
      <div className="rounded-lg border border-border bg-surface p-5 text-center">
        <p className="text-xs uppercase tracking-wider text-muted">
          Probability of passing today
        </p>
        <p
          className={`mt-1 font-heading text-4xl font-extrabold ${scoreColor(passProb)}`}
        >
          {passProb}%
        </p>
        <p className="mt-2 text-sm text-muted">
          {hoursNeeded === 0 ? (
            <>You&apos;re in the passing zone — daily reviews keep it that way.</>
          ) : (
            <>
              <span className="font-medium text-foreground">~{hoursNeeded}h</span>{' '}
              of focused practice (~{weeks} {weeks === 1 ? 'week' : 'weeks'} at
              1h/day) closes the gap to the passing zone.
            </>
          )}
        </p>
      </div>

      {/* Domain Breakdown */}
      <div>
          <h3 className="mb-4 font-heading text-lg font-extrabold">
            Domain Breakdown
          </h3>
          <div className="space-y-3">
            {result.domainScores.map((ds) => (
              <div
                key={ds.domainId}
                className="rounded-lg border border-border bg-surface p-4"
              >
                <div className="flex items-center justify-between">
                  <div>
                    <span className="text-xs text-muted">{ds.domainCode}</span>
                    <p className="text-sm font-medium text-foreground">
                      {ds.domainName}
                      {ds.domainId === result.weakestDomainId && (
                        <span className="ml-2 rounded-full bg-danger/20 px-2 py-0.5 text-xs font-medium text-danger">
                          Focus here first
                        </span>
                      )}
                    </p>
                  </div>
                  <span
                    className={`font-heading text-lg font-extrabold ${scoreColor(ds.percentage)}`}
                  >
                    {ds.correct}/{ds.total}
                  </span>
                </div>
                <div className="mt-2 h-2 overflow-hidden rounded-full bg-background">
                  <div
                    className={`h-full rounded-full transition-all duration-500 ${barColor(ds.percentage)}`}
                    style={{ width: `${ds.percentage}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

      {/* Scientific social proof — pre-CTA reassurance for a user who has
          already submitted their email and is deciding whether to pay. */}
      <div className="rounded-lg border border-accent/20 bg-accent/5 p-4">
        <p className="text-sm text-foreground">
          <span className="font-medium text-accent">Why this works:</span>{' '}
          Spaced repetition is one of the most-studied learning techniques in
          cognitive science. Meta-analyses show it can produce 2× better
          long-term retention than massed practice.
        </p>
        <p className="mt-2 text-xs text-muted">
          Cepeda et al. (2006), <em>Psychological Bulletin</em>, meta-analysis of 317 experiments.
        </p>
      </div>

      {/* Plan + paid CTA */}
      <div className="rounded-lg border border-accent/30 bg-surface p-6">
          {isInPassingZone ? (
            <>
              <h3 className="font-heading text-lg font-extrabold">
                You&apos;re already close. Don&apos;t let it slip.
              </h3>
              <p className="mt-2 text-sm text-muted">
                At a readiness score of {readiness}, the biggest risk is
                forgetting what you already know before exam day. SM-2 keeps
                every correct answer fresh and surfaces the few weak spots that
                could still cost you the pass.
              </p>
              <ul className="mt-4 space-y-2 text-sm text-foreground">
                <li className="flex gap-3">
                  <span className="mt-0.5 text-accent">✓</span>
                  <span>
                    Daily 10-question reviews keep your recall sharp with
                    minimum time invested.
                  </span>
                </li>
                <li className="flex gap-3">
                  <span className="mt-0.5 text-accent">✓</span>
                  <span>
                    Full 90-question timed exams to train stamina under real
                    exam conditions.
                  </span>
                </li>
                <li className="flex gap-3">
                  <span className="mt-0.5 text-accent">✓</span>
                  <span>
                    Targeted drills on{' '}
                    <span className="text-danger">
                      {weakestDomainName}
                    </span>{' '}
                    — the only domain still pulling your score down.
                  </span>
                </li>
              </ul>

              <p className="mt-5 text-center text-sm text-muted">
                Target:{' '}
                <span className="font-medium text-foreground">{readiness}</span>{' '}
                → <span className="font-medium text-accent">90+</span> before
                exam day
              </p>

              <div className="mt-4 text-center">
                {isLoggedIn ? (
                  <form
                    action={createCheckoutAndRedirect}
                    className="inline-block"
                  >
                    <button
                      type="submit"
                      className="rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
                    >
                      Start {TRIAL_DAYS}-day free trial — then {PRICE_LABEL}
                    </button>
                  </form>
                ) : (
                  <a
                    href="/auth/login?next=/dashboard"
                    className="inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
                  >
                    Start {TRIAL_DAYS}-day free trial — then {PRICE_LABEL}
                  </a>
                )}
                <p className="mt-2 text-xs text-muted">
                  Free for {TRIAL_DAYS} days, then {PRICE_LABEL} · Cancel anytime
                </p>
              </div>
            </>
          ) : (
            <>
              <h3 className="font-heading text-lg font-extrabold">
                Your path to Ready-to-Pass
              </h3>
              <p className="mt-1 text-sm text-muted">
                With SM-2 spaced repetition, here&apos;s how {weeks}{' '}
                {weeks === 1 ? 'week' : 'weeks'} of focused practice closes your gap:
              </p>
              <ol className="mt-4 space-y-2 text-sm text-foreground">
                {buildPhasePlan(weeks, weakestDomainName).map(
                  (phase, i) => (
                    <li key={phase.rangeLabel} className="flex gap-3">
                      <span className="flex h-6 w-6 shrink-0 items-center justify-center rounded-full bg-accent/20 text-xs font-medium text-accent">
                        {i + 1}
                      </span>
                      <span>
                        <span className="font-medium">{phase.rangeLabel}:</span>{' '}
                        {phase.body}
                      </span>
                    </li>
                  ),
                )}
              </ol>

              <p className="mt-5 text-center text-sm text-muted">
                Projected readiness:{' '}
                <span className="font-medium text-foreground">{readiness}</span>{' '}
                → <span className="font-medium text-accent">82+</span>
              </p>

              <div className="mt-4 text-center">
                {isLoggedIn ? (
                  <form
                    action={createCheckoutAndRedirect}
                    className="inline-block"
                  >
                    <button
                      type="submit"
                      className="rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
                    >
                      Start {TRIAL_DAYS}-day free trial — then {PRICE_LABEL}
                    </button>
                  </form>
                ) : (
                  <a
                    href="/auth/login?next=/dashboard"
                    className="inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
                  >
                    Start {TRIAL_DAYS}-day free trial — then {PRICE_LABEL}
                  </a>
                )}
                <p className="mt-2 text-xs text-muted">
                  Free for {TRIAL_DAYS} days, then {PRICE_LABEL} · Cancel anytime
                </p>
              </div>
            </>
          )}
      </div>
    </div>
  )
}
