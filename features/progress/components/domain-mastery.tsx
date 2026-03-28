interface DomainData {
  domainId: string
  domainName: string
  code: string
  weightPct: number
  correctPct: number
  totalAnswered: number
}

interface DomainMasteryProps {
  domains: DomainData[]
}

export function DomainMastery({ domains }: DomainMasteryProps) {
  return (
    <div className="rounded-lg border border-border bg-surface p-6">
      <h3 className="font-heading text-lg font-extrabold">Domain Mastery</h3>
      <div className="mt-4 space-y-4">
        {domains.map((domain) => (
          <div key={domain.domainId}>
            <div className="mb-1 flex items-center justify-between text-sm">
              <span className="text-foreground">
                {domain.code} {domain.domainName}
              </span>
              <span className="text-muted">
                {domain.correctPct}%
                <span className="ml-1 text-xs">
                  ({domain.totalAnswered} answered)
                </span>
              </span>
            </div>
            <div className="h-2 rounded-full bg-background">
              <div
                className="h-full rounded-full bg-accent transition-all duration-500"
                style={{ width: `${domain.correctPct}%` }}
              />
            </div>
          </div>
        ))}
        {domains.length === 0 && (
          <p className="text-sm text-muted">
            No data yet. Start practicing to see your progress.
          </p>
        )}
      </div>
    </div>
  )
}
