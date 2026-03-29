'use client'

interface QuestionCardProps {
  optionKey: string
  text: string
  isSelected: boolean
  isSubmitted: boolean
  isCorrect?: boolean
  isSelectedWrong?: boolean
  onClick: () => void
}

export function QuestionCard({
  optionKey,
  text,
  isSelected,
  isSubmitted,
  isCorrect,
  isSelectedWrong,
  onClick,
}: QuestionCardProps) {
  let borderClass = 'border-border'
  let bgClass = 'bg-surface'

  if (isSubmitted) {
    if (isCorrect) {
      borderClass = 'border-accent'
      bgClass = 'bg-accent/10'
    } else if (isSelectedWrong) {
      borderClass = 'border-danger'
      bgClass = 'bg-danger/10'
    }
  } else if (isSelected) {
    borderClass = 'border-accent'
    bgClass = 'bg-accent/5'
  }

  return (
    <button
      onClick={onClick}
      disabled={isSubmitted}
      className={`w-full rounded-lg border ${borderClass} ${bgClass} px-4 py-3 text-left transition-all ${
        !isSubmitted ? 'cursor-pointer hover:border-accent/50' : 'cursor-default'
      }`}
    >
      <div className="flex items-start gap-3">
        <span
          className={`flex h-7 w-7 shrink-0 items-center justify-center rounded-md border text-xs font-medium ${
            isSubmitted && isCorrect
              ? 'border-accent bg-accent text-[#060b06]'
              : isSelectedWrong
                ? 'border-danger bg-danger text-white'
                : isSelected
                  ? 'border-accent text-accent'
                  : 'border-border text-muted'
          }`}
        >
          {optionKey}
        </span>
        <span className="text-sm leading-relaxed text-foreground">{text}</span>
      </div>
    </button>
  )
}
