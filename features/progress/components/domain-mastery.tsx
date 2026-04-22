import Link from 'next/link'

// Below this many unique answered questions, accuracy isn't statistically
// meaningful. The UI flags the domain so users don't read the % as reliable.
const MIN_SAMPLE = 10

interface DomainData {
  domainId: string
  domainName: string
  code: string
  weightPct: number
  correctPct: number
  coveredPct: number
  totalAnswered: number
  totalInDomain: number
}

interface DomainMasteryProps {
  domains: DomainData[]
  examSlug: string
}

export function DomainMastery({ domains, examSlug }: DomainMasteryProps) {
  return (
    <div id="domains" className="rounded-lg border border-border bg-surface p-6">
      <h3 className="font-heading text-lg font-extrabold">Domain Mastery</h3>
      <p className="mt-1 text-xs text-muted">
        Accuracy on questions you&apos;ve practiced · Click to focus on a domain
      </p>
      <div className="mt-4 space-y-3">
        {domains.map((domain) => {
          const insufficient = domain.totalAnswered < MIN_SAMPLE
          return (
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
                  {insufficient && (
                    <span
                      title={`Answer at least ${MIN_SAMPLE} questions in this domain for a reliable score`}
                      className="rounded-full border border-border bg-background px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted"
                    >
                      Low sample
                    </span>
                  )}
                  <span
                    className={
                      insufficient
                        ? 'font-medium text-muted'
                        : 'font-medium text-foreground'
                    }
                  >
                    {domain.correctPct}%
                  </span>
                  <span className="text-muted">&#8250;</span>
                </div>
              </div>
              {/* Accuracy bar */}
              <div className="h-2 rounded-full bg-background">
                <div
                  className={`h-full rounded-full transition-all duration-500 ${
                    insufficient ? 'bg-accent/30' : 'bg-accent'
                  }`}
                  style={{ width: `${domain.correctPct}%` }}
                />
              </div>
              {/* Coverage info */}
              <div className="mt-1.5 flex items-center justify-between">
                <span className="text-xs text-muted">
                  {domain.totalAnswered} / {domain.totalInDomain} questions seen
                </span>
                <span className="text-xs text-muted">
                  {domain.coveredPct}% covered · {domain.weightPct}% of exam
                </span>
              </div>
            </Link>
          )
        })}
        {domains.length === 0 && (
          <p className="text-sm text-muted">
            No data yet. Start practicing to see your progress.
          </p>
        )}
      </div>
    </div>
  )
}
