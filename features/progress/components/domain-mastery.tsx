import Link from 'next/link'

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
  examSlug: string
}

export function DomainMastery({ domains, examSlug }: DomainMasteryProps) {
  return (
    <div id="domains" className="rounded-lg border border-border bg-surface p-6">
      <h3 className="font-heading text-lg font-extrabold">Domain Mastery</h3>
      <p className="mt-1 text-xs text-muted">Click a domain to practice</p>
      <div className="mt-4 space-y-2">
        {domains.map((domain) => (
          <Link
            key={domain.domainId}
            href={`/quiz/${examSlug}?mode=domain_focus&domainId=${domain.domainId}`}
            className="-mx-3 block rounded-lg px-3 py-3 transition-colors hover:bg-accent/5"
          >
            <div className="mb-1 flex items-center justify-between text-sm">
              <span className="text-foreground">
                {domain.code} {domain.domainName}
              </span>
              <div className="flex items-center gap-2">
                <span className="text-muted">
                  {domain.correctPct}%
                  <span className="ml-1 text-xs">
                    ({domain.totalAnswered} answered)
                  </span>
                </span>
                <span className="text-muted">&#8250;</span>
              </div>
            </div>
            <div className="h-2 rounded-full bg-background">
              <div
                className="h-full rounded-full bg-accent transition-all duration-500"
                style={{ width: `${domain.correctPct}%` }}
              />
            </div>
          </Link>
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
