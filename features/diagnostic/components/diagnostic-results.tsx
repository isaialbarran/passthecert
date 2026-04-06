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

function scoreColor(percentage: number): string {
  if (percentage >= 80) return 'text-accent'
  if (percentage >= 60) return 'text-yellow-400'
  return 'text-danger'
}

export function DiagnosticResults({
  result,
  isUnlocked,
  isLoggedIn,
}: DiagnosticResultsProps) {
  return (
    <div className="space-y-8">
      {/* Overall Score */}
      <div className="text-center">
        <p className="text-sm text-muted">Your Overall Score</p>
        <p
          className={`font-heading text-7xl font-extrabold ${scoreColor(result.overallScore)}`}
        >
          {result.overallScore}%
        </p>
        <p className="mt-2 text-sm text-muted">
          {result.correctCount} of {result.totalQuestions} correct
        </p>
        <p className="mt-1 text-sm text-muted">
          {result.overallScore >= 80
            ? 'Great foundation — you\'re close to exam-ready!'
            : result.overallScore >= 60
              ? 'Solid start — some domains need more work.'
              : 'You\'ve identified key gaps — let\'s close them.'}
        </p>
      </div>

      {/* Domain Breakdown */}
      <div className="relative">
        {!isUnlocked && (
          <div className="pointer-events-none absolute inset-0 z-10" />
        )}
        <div className={!isUnlocked ? 'select-none blur-[8px]' : ''}>
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
                    className={`h-full rounded-full transition-all duration-500 ${
                      ds.percentage >= 80
                        ? 'bg-accent'
                        : ds.percentage >= 60
                          ? 'bg-yellow-400'
                          : 'bg-danger'
                    }`}
                    style={{ width: `${ds.percentage}%` }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* CTA (only when unlocked) */}
      {isUnlocked && (
        <div className="text-center">
          <p className="mb-4 text-sm text-muted">
            Your weakest domain is{' '}
            <span className="font-medium text-danger">
              {result.weakestDomainName}
            </span>
            . Start there with targeted practice.
          </p>
          {isLoggedIn ? (
            <form action={createCheckoutAndRedirect} className="inline-block">
              <button
                type="submit"
                className="rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
              >
                Start Your Study Plan — {PRICE_LABEL}
              </button>
            </form>
          ) : (
            <a
              href="/auth/login?source=diagnostic&redirect=/dashboard"
              className="inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
            >
              Start Your Study Plan — {PRICE_LABEL}
            </a>
          )}
          <p className="mt-2 text-xs text-muted">
            7-day money-back guarantee
          </p>
        </div>
      )}
    </div>
  )
}
