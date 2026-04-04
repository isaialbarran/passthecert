'use server'

import { createClient } from '@/shared/lib/supabase'
import { requireAuth } from '@/features/auth'
import { calculateSM2 } from './sm2'
import { updateReadinessScore } from '@/features/progress/actions'
import { isPro, getDailyQuestionCount } from '@/features/billing'
import type { QuizMode } from './types'
import type { Question } from '@/shared/types/database'

const FREE_DAILY_LIMIT = 20

export async function startQuizSession(
  examSlug: string,
  mode: QuizMode,
  domainId?: string
) {
  const user = await requireAuth()
  const supabase = await createClient()

  // Billing gate: full_exam requires Pro
  const userIsPro = await isPro(user.id)
  if (mode === 'full_exam' && !userIsPro) {
    throw new Error('Full exam mode requires a Pro subscription')
  }

  // Free tier: check daily question limit
  if (!userIsPro) {
    const dailyCount = await getDailyQuestionCount(user.id)
    if (dailyCount >= FREE_DAILY_LIMIT) {
      throw new Error('Daily question limit reached. Upgrade to Pro for unlimited access.')
    }
  }

  const { data: exam } = await supabase
    .from('exams')
    .select('id')
    .eq('slug', examSlug)
    .single()

  if (!exam) throw new Error('Exam not found')

  const totalQuestions =
    mode === 'random_10' ? 10 : mode === 'full_exam' ? 90 : 10

  const { data: session, error } = await supabase
    .from('quiz_sessions')
    .insert({
      user_id: user.id,
      exam_id: exam.id,
      mode,
      domain_id: domainId || null,
      total_questions: totalQuestions,
    })
    .select()
    .single()

  if (error) throw new Error(error.message)

  const firstQuestion = await getNextQuestionForSession(
    supabase,
    user.id,
    exam.id,
    session.id,
    mode,
    domainId
  )

  return { sessionId: session.id, question: firstQuestion, totalQuestions }
}

export async function getNextQuestion(sessionId: string) {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: session } = await supabase
    .from('quiz_sessions')
    .select('*')
    .eq('id', sessionId)
    .eq('user_id', user.id)
    .single()

  if (!session) throw new Error('Session not found')
  if (session.is_completed) return null

  const { count } = await supabase
    .from('user_responses')
    .select('*', { count: 'exact', head: true })
    .eq('session_id', sessionId)

  if ((count ?? 0) >= session.total_questions) {
    await completeSession(sessionId)
    return null
  }

  return getNextQuestionForSession(
    supabase,
    user.id,
    session.exam_id,
    sessionId,
    session.mode as QuizMode,
    session.domain_id
  )
}

export async function submitAnswer(
  sessionId: string,
  questionId: string,
  selectedKey: string,
  timeSpentSecs?: number
) {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: question } = await supabase
    .from('questions')
    .select('correct_key, explanation')
    .eq('id', questionId)
    .single()

  if (!question) throw new Error('Question not found')

  const isCorrect = selectedKey === question.correct_key

  // Get previous SM-2 state for this user+question
  const { data: previousResponse } = await supabase
    .from('user_responses')
    .select('repetitions, ease_factor, interval_days')
    .eq('user_id', user.id)
    .eq('question_id', questionId)
    .order('created_at', { ascending: false })
    .limit(1)
    .single()

  const sm2Result = calculateSM2({
    isCorrect,
    quality: isCorrect ? 4 : 1,
    repetitions: previousResponse?.repetitions ?? 0,
    easeFactor: previousResponse?.ease_factor ?? 2.5,
    intervalDays: previousResponse?.interval_days ?? 1,
  })

  await supabase.from('user_responses').insert({
    user_id: user.id,
    question_id: questionId,
    selected_key: selectedKey,
    is_correct: isCorrect,
    time_spent_secs: timeSpentSecs ?? null,
    repetitions: sm2Result.repetitions,
    ease_factor: sm2Result.easeFactor,
    interval_days: sm2Result.intervalDays,
    next_review_at: sm2Result.nextReviewAt.toISOString(),
    session_id: sessionId,
  })

  // Update session correct count
  if (isCorrect) {
    const { data: session } = await supabase
      .from('quiz_sessions')
      .select('correct_count')
      .eq('id', sessionId)
      .single()

    await supabase
      .from('quiz_sessions')
      .update({ correct_count: (session?.correct_count ?? 0) + 1 })
      .eq('id', sessionId)
  }

  // Update readiness score
  const { data: sessionForExam } = await supabase
    .from('quiz_sessions')
    .select('exam_id')
    .eq('id', sessionId)
    .single()

  if (sessionForExam) {
    await updateReadinessScore(user.id, sessionForExam.exam_id)
  }

  // Get progress
  const { count } = await supabase
    .from('user_responses')
    .select('*', { count: 'exact', head: true })
    .eq('session_id', sessionId)

  const { data: sessionData } = await supabase
    .from('quiz_sessions')
    .select('total_questions')
    .eq('id', sessionId)
    .single()

  return {
    isCorrect,
    correctKey: question.correct_key,
    explanation: question.explanation,
    questionIndex: count ?? 0,
    totalQuestions: sessionData?.total_questions ?? 0,
  }
}

export async function completeSession(sessionId: string) {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: session } = await supabase
    .from('quiz_sessions')
    .select('total_questions, correct_count')
    .eq('id', sessionId)
    .eq('user_id', user.id)
    .single()

  if (!session) throw new Error('Session not found')

  const scorePct = Math.round(
    (session.correct_count / session.total_questions) * 100
  )

  await supabase
    .from('quiz_sessions')
    .update({
      is_completed: true,
      completed_at: new Date().toISOString(),
      score_pct: scorePct,
    })
    .eq('id', sessionId)

  return { scorePct, correctCount: session.correct_count, totalQuestions: session.total_questions }
}

async function getNextQuestionForSession(
  // eslint-disable-next-line @typescript-eslint/no-explicit-any -- query builder needs flexible typing for chained .select()
  supabase: any,
  userId: string,
  examId: string,
  sessionId: string,
  mode: QuizMode,
  domainId?: string | null
): Promise<Question | null> {
  // Get already-answered question IDs in this session
  const { data: answered } = await supabase
    .from('user_responses')
    .select('question_id')
    .eq('session_id', sessionId)

  const answeredIds = (answered ?? []).map(
    (r: { question_id: string }) => r.question_id
  )

  let query = supabase
    .from('questions')
    .select('*')
    .eq('exam_id', examId)
    .eq('is_active', true)

  if (answeredIds.length > 0) {
    query = query.not('id', 'in', `(${answeredIds.join(',')})`)
  }

  if (mode === 'domain_focus' && domainId) {
    query = query.eq('domain_id', domainId)
  }

  if (mode === 'review_mistakes') {
    const thirtyDaysAgo = new Date()
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

    const { data: wrongQuestions } = await supabase
      .from('user_responses')
      .select('question_id')
      .eq('user_id', userId)
      .eq('is_correct', false)
      .gte('created_at', thirtyDaysAgo.toISOString())

    const wrongIds = (wrongQuestions ?? []).map(
      (r: { question_id: string }) => r.question_id
    )

    if (wrongIds.length === 0) return null

    const filteredIds = wrongIds.filter(
      (id: string) => !answeredIds.includes(id)
    )
    if (filteredIds.length === 0) return null

    query = supabase
      .from('questions')
      .select('*')
      .in('id', filteredIds)
      .eq('is_active', true)
  }

  // Random ordering via limit 1 with random offset
  const { count } = await query.select('*', { count: 'exact', head: true })

  if (!count || count === 0) return null

  const randomOffset = Math.floor(Math.random() * count)

  const { data: questions } = await query
    .range(randomOffset, randomOffset)
    .limit(1)

  return questions?.[0] ?? null
}
