import Link from 'next/link'

interface StartPracticeCtaProps {
  examSlug: string
}

export function StartPracticeCta({ examSlug }: StartPracticeCtaProps) {
  return (
    <div className="flex flex-col items-center gap-4 rounded-lg border border-border bg-surface p-8">
      <h3 className="font-heading text-xl font-extrabold">
        Ready to practice?
      </h3>
      <div className="flex flex-wrap gap-3">
        <Link
          href={`/quiz/${examSlug}?mode=random_10`}
          className="rounded-lg bg-accent px-6 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
        >
          Quick 10 Questions
        </Link>
        <Link
          href={`/quiz/${examSlug}?mode=review_mistakes`}
          className="rounded-lg border border-border bg-surface px-6 py-3 text-sm font-medium text-foreground transition-colors hover:bg-accent/10"
        >
          Review Mistakes
        </Link>
        <Link
          href={`/quiz/${examSlug}?mode=full_exam`}
          className="rounded-lg border border-border bg-surface px-6 py-3 text-sm font-medium text-foreground transition-colors hover:bg-accent/10"
        >
          Full Exam (90 min)
        </Link>
      </div>
    </div>
  )
}
