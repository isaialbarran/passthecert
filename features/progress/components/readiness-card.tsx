interface ReadinessCardProps {
  score: number
}

function getLabel(score: number) {
  if (score >= 70) return 'Ready to Pass'
  if (score >= 40) return 'Getting There'
  return 'Not Ready'
}

export function ReadinessCard({ score }: ReadinessCardProps) {
  return (
    <div className="rounded-lg border border-border bg-surface p-6">
      <p className="text-sm text-muted">Readiness Score</p>
      <p className="mt-2 font-heading text-5xl font-extrabold text-accent">
        {score}%
      </p>
      <p className="mt-1 text-xs text-muted">{getLabel(score)}</p>
    </div>
  )
}
