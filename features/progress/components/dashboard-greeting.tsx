'use client'

import { useSyncExternalStore } from 'react'
import type { JSX } from 'react'

interface DashboardGreetingProps {
  firstName: string
  examName: string
  readinessScore: number
  streak: number
  mastered: number
}

function getGreeting(hour: number): string {
  if (hour >= 5 && hour < 12) return 'Good morning'
  if (hour >= 12 && hour < 18) return 'Good afternoon'
  return 'Good evening'
}

function getReadinessLabel(score: number): string {
  if (score >= 70) return 'Ready to Pass'
  if (score >= 40) return 'Getting There'
  return 'Not Ready'
}

export function DashboardGreeting({
  firstName,
  examName,
  readinessScore,
  streak,
  mastered,
}: DashboardGreetingProps): JSX.Element {
  // useSyncExternalStore gives '' on the server (preventing hydration mismatch)
  // and the real greeting on the client after mount.
  const greeting = useSyncExternalStore(
    () => () => {},
    () => getGreeting(new Date().getHours()),
    () => '',
  )

  return (
    <div className="rounded-lg border border-border bg-surface p-6">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 className="font-heading text-3xl font-extrabold">
            {greeting}, {firstName}
          </h1>
          <p className="mt-1 text-sm text-muted">{examName}</p>
          <div className="mt-3 flex flex-wrap gap-3">
            <span className="inline-flex items-center gap-1.5 rounded-full border border-border bg-background px-3 py-1 text-xs text-muted">
              🔥 <span className="font-medium text-foreground">{streak}</span> day streak
            </span>
            <span className="inline-flex items-center gap-1.5 rounded-full border border-border bg-background px-3 py-1 text-xs text-muted">
              ✓ <span className="font-medium text-foreground">{mastered}</span> mastered
            </span>
          </div>
        </div>
        <div className="sm:text-right">
          <p className="font-heading text-5xl font-extrabold text-accent">{readinessScore}%</p>
          <p className="mt-1 text-xs text-muted">{getReadinessLabel(readinessScore)}</p>
        </div>
      </div>
    </div>
  )
}
