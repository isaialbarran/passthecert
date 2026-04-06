'use client'

import { useState, useTransition } from 'react'
import { submitDiagnosticLead } from '../actions'
import type { DiagnosticResult } from '../types'

interface EmailGateProps {
  result: DiagnosticResult
  onUnlock: () => void
}

export function EmailGate({ result, onUnlock }: EmailGateProps) {
  const [email, setEmail] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [isPending, startTransition] = useTransition()

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError(null)

    const domainScores: Record<string, { percentage: number; correct: number; total: number }> = {}
    for (const ds of result.domainScores) {
      domainScores[ds.domainId] = {
        percentage: ds.percentage,
        correct: ds.correct,
        total: ds.total,
      }
    }

    startTransition(async () => {
      const res = await submitDiagnosticLead({
        email,
        overallScore: result.overallScore,
        domainScores,
        weakestDomainId: result.weakestDomainId,
      })

      if (res.success) {
        onUnlock()
      } else {
        setError(res.error ?? 'Something went wrong. Please try again.')
      }
    })
  }

  return (
    <div className="rounded-lg border border-accent/30 bg-surface p-6">
      <h3 className="font-heading text-lg font-extrabold">
        Unlock Your Domain Breakdown
      </h3>
      <p className="mt-2 text-sm text-muted">
        Enter your email to see exactly which domains need work — plus get a
        personalized study plan sent to your inbox.
      </p>

      <form onSubmit={handleSubmit} className="mt-4 flex gap-3">
        <input
          type="email"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="you@example.com"
          className="flex-1 rounded-lg border border-border bg-background px-4 py-3 text-sm text-foreground placeholder:text-muted/60 focus:border-accent focus:outline-none"
        />
        <button
          type="submit"
          disabled={isPending}
          className="rounded-lg bg-accent px-6 py-3 text-sm font-medium text-[#060b06] transition-opacity disabled:opacity-40"
        >
          {isPending ? 'Sending...' : 'Unlock Results'}
        </button>
      </form>

      {error && (
        <p className="mt-3 text-sm text-danger">{error}</p>
      )}

      <p className="mt-3 text-xs text-muted/60">
        No spam. Just your diagnostic report and study recommendations.
      </p>
    </div>
  )
}
