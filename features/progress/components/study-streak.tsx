interface StudyStreakProps {
  streak: number
}

export function StudyStreak({ streak }: StudyStreakProps) {
  return (
    <div className="rounded-lg border border-border bg-surface p-6">
      <p className="text-sm text-muted">Study Streak</p>
      <p className="mt-2 font-heading text-4xl font-extrabold text-accent">
        {streak}
      </p>
      <p className="mt-1 text-xs text-muted">consecutive days</p>
    </div>
  )
}
