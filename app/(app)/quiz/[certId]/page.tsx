import { startQuizSession } from '@/features/quiz'
import type { QuizMode } from '@/features/quiz'
import { QuizClient } from '@/features/quiz/components/quiz-client'
import { requireAuth } from '@/features/auth'
import { isPro, Paywall } from '@/features/billing'

export default async function QuizPage({
  params,
  searchParams,
}: {
  params: Promise<{ certId: string }>
  searchParams: Promise<{ mode?: string; domainId?: string }>
}) {
  const user = await requireAuth()
  const userIsPro = await isPro(user.id)

  const { certId } = await params
  const { mode = 'random_10', domainId } = await searchParams

  if (!userIsPro) {
    const proOnlyModes: ReadonlyArray<string> = [
      'full_exam',
      'review_mistakes',
      'domain_focus',
    ]
    const source = proOnlyModes.includes(mode)
      ? (mode as 'full_exam' | 'review_mistakes' | 'domain_focus')
      : 'quiz'
    return <Paywall source={source} />
  }

  const { sessionId, question, totalQuestions } = await startQuizSession(
    certId,
    mode as QuizMode,
    domainId,
    { userId: user.id, isPro: userIsPro }
  )

  if (!question) {
    return (
      <div className="flex flex-col items-center gap-4 py-20">
        <h2 className="font-heading text-2xl font-extrabold">
          No questions available
        </h2>
        <p className="text-muted">
          {mode === 'review_mistakes'
            ? 'No mistakes to review. Great job!'
            : 'No questions found for this selection.'}
        </p>
      </div>
    )
  }

  return (
    <QuizClient
      sessionId={sessionId}
      initialQuestion={question}
      totalQuestions={totalQuestions}
    />
  )
}
