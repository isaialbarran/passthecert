interface Session {
  id: string
  mode: string
  correct_count: number
  total_questions: number
  score_pct: number | null
  created_at: string
  exams: { name: string } | null
}

interface RecentSessionsProps {
  sessions: Session[]
}

const modeLabels: Record<string, string> = {
  random_10: 'Quick 10',
  full_exam: 'Full Exam',
  review_mistakes: 'Review Mistakes',
  domain_focus: 'Domain Focus',
}

export function RecentSessions({ sessions }: RecentSessionsProps) {
  if (sessions.length === 0) {
    return null
  }

  return (
    <div className="rounded-lg border border-border bg-surface p-6">
      <h3 className="font-heading text-lg font-extrabold">Recent Sessions</h3>
      <div className="mt-4 divide-y divide-border">
        {sessions.map((session) => (
          <div
            key={session.id}
            className="flex items-center justify-between py-3 first:pt-0 last:pb-0"
          >
            <div>
              <p className="text-sm font-medium text-foreground">
                {modeLabels[session.mode] ?? session.mode}
              </p>
              <p className="text-xs text-muted">
                {new Date(session.created_at).toLocaleDateString()}
              </p>
            </div>
            <div className="text-right">
              <p className="text-sm font-medium text-accent">
                {session.score_pct ?? 0}%
              </p>
              <p className="text-xs text-muted">
                {session.correct_count}/{session.total_questions}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
