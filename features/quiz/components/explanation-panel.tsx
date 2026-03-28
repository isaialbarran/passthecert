'use client'

interface ExplanationPanelProps {
  explanation: string
  isCorrect: boolean
}

export function ExplanationPanel({
  explanation,
  isCorrect,
}: ExplanationPanelProps) {
  return (
    <div
      className={`rounded-lg border p-4 ${
        isCorrect
          ? 'border-accent/30 bg-accent/5'
          : 'border-danger/30 bg-danger/5'
      }`}
    >
      <p
        className={`mb-2 text-sm font-medium ${
          isCorrect ? 'text-accent' : 'text-danger'
        }`}
      >
        {isCorrect ? 'Correct!' : 'Incorrect'}
      </p>
      <p className="text-sm leading-relaxed text-foreground/80">
        {explanation}
      </p>
    </div>
  )
}
