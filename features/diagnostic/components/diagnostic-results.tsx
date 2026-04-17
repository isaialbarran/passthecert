'use client'

import type { DiagnosticResult } from '../types'
// Direct imports required: this is a 'use client' component — importing from
// the barrel @/features/billing would pull in server-only query modules that
// use next/headers. Server action modules ('use server') are safe as they
// become RPC stubs on the client.
import { createCheckoutAndRedirect } from '@/features/billing/actions'
import { PRICE_LABEL } from '@/features/billing/constants'

interface DiagnosticResultsProps {
  result: DiagnosticResult
  isUnlocked: boolean
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
// Calibrated so that score=75 (passing zone) ~= 65% probability,
// score=40 ~= 18%, score=90 ~= 90%.
function passProbabilityToday(score: number): number {
  if (score <= 20) return 5
  if (score >= 95) return 95
  const p = Math.round(1.15 * score - 28)
  return Math.max(5, Math.min(95, p))
}

// Estimated hours of focused practice to reach the passing zone.
// Assumes ~1.2h per readiness point gained with spaced repetition.
function hoursToReady(score: number): number {
  const gap = Math.max(0, PASSING_ZONE - score)
  return Math.round(gap * 1.2)
}

function readinessLabel(score: number): string {
  if (score >= PASSING_ZONE) return "You're in the passing zone — keep sharpening."
  if (score >= 55) return 'Solid foundation — targeted practice will close the gap.'
  if (score >= 35) return 'Meaningful gaps identified — a plan fixes this fast.'
  if (score >= 21) return "You're far from ready today — but that's exactly what this tool fixes."
  return "Starting from scratch is a feature, not a bug — SM-2 builds memory right the first time."
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
  isUnlocked,
  isLoggedIn,
}: DiagnosticResultsProps) {
  const readiness = result.overallScore
  const passProb = passProbabilityToday(readiness)
  const hoursNeeded = hoursToReady(readiness)
  const weeks = Math.max(1, Math.ceil(hoursNeeded / 8)) // ~1h/day × 8 days per "week block"

  return (
    <div className="space-y-8">
      {/* Readiness Score */}
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
          {result.correctCount} of {result.totalQuestions} correct · Passing zone starts at {PASSING_ZONE}
        </p>

        {/* Progress bar with passing zone marker */}
        <div className="relative mx-auto mt-4 h-3 w-full max-w-md overflow-hidden rounded-full bg-background">
          <div
            className={`h-full rounded-full transition-all duration-700 ${barColor(readiness)}`}
            style={{ width: `${readiness}%` }}
          />
          <div
            className="absolute top-0 h-full w-0.5 bg-accent/60"
            style={{ left: `${PASSING_ZONE}%` }}
            aria-label="Passing zone marker"
          />
        </div>
        <p className="mt-3 text-sm text-muted">{readinessLabel(readiness)}</p>
      </div>

      {/* Key metrics: Pass probability + Time to ready */}
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <div className="rounded-lg border border-border bg-surface p-4 text-center">
          <p className="text-xs uppercase tracking-wider text-muted">
            Probability of passing today
          </p>
          <p
            className={`mt-1 font-heading text-3xl font-extrabold ${scoreColor(passProb)}`}
          >
            {passProb}%
          </p>
          <p className="mt-1 text-xs text-muted">
            Based on your current score vs. the 75-point passing zone.
          </p>
        </div>
        <div className="rounded-lg border border-border bg-surface p-4 text-center">
          <p className="text-xs uppercase tracking-wider text-muted">
            Focused practice to be ready
          </p>
          <p className="mt-1 font-heading text-3xl font-extrabold text-foreground">
            ~{hoursNeeded}h
          </p>
          <p className="mt-1 text-xs text-muted">
            About {weeks} {weeks === 1 ? 'week' : 'weeks'} at 1h/day with spaced repetition.
          </p>
        </div>
      </div>

      {/* Weakest Domain Teaser (blurred before email) */}
      {!isUnlocked && (
        <div className="rounded-lg border border-danger/30 bg-surface p-5">
          <p className="text-xs uppercase tracking-wider text-muted">
            Your weakest domain
          </p>
          <div className="mt-2 flex items-center justify-between">
            <p className="select-none font-heading text-lg font-extrabold text-danger blur-[6px]">
              ████████████████████
            </p>
            <span className="select-none font-heading text-lg font-extrabold text-danger blur-[6px]">
              ██%
            </span>
          </div>
          <p className="mt-3 text-sm text-muted">
            One domain is pulling your score down more than the others.
            Knowing which one lets you focus the first two weeks of practice
            where it matters most.
          </p>
        </div>
      )}

      {/* Domain Breakdown (revealed after email) */}
      {isUnlocked && (
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
      )}

      {/* Scientific social proof (honest, cited) */}
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

      {/* Plan + paid CTA (only when unlocked) */}
      {isUnlocked && (
        <div className="rounded-lg border border-accent/30 bg-surface p-6">
          {readiness >= 80 ? (
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
                      {result.weakestDomainName}
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
                      Lock it in with full-length exams — {PRICE_LABEL}
                    </button>
                  </form>
                ) : (
                  <a
                    href="/auth/login?next=/dashboard"
                    className="inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
                  >
                    Lock it in with full-length exams — {PRICE_LABEL}
                  </a>
                )}
                <p className="mt-2 text-xs text-muted">
                  7-day money-back guarantee · Cancel anytime
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
                {buildPhasePlan(weeks, result.weakestDomainName).map(
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
                      Start my plan — {PRICE_LABEL}
                    </button>
                  </form>
                ) : (
                  <a
                    href="/auth/login?next=/dashboard"
                    className="inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
                  >
                    Start my plan — {PRICE_LABEL}
                  </a>
                )}
                <p className="mt-2 text-xs text-muted">
                  7-day money-back guarantee · Cancel anytime
                </p>
              </div>
            </>
          )}
        </div>
      )}
    </div>
  )
}
