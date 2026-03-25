import { createClient } from '@/shared/lib/supabase'

export async function getReadinessScore(userId: string, examId: string) {
  const supabase = await createClient()

  const { data } = await supabase
    .from('readiness_scores')
    .select('*')
    .eq('user_id', userId)
    .eq('exam_id', examId)
    .single()

  return data
}

export async function getDomainMastery(userId: string, examId: string) {
  const supabase = await createClient()

  const { data: domains } = await supabase
    .from('domains')
    .select('id, name, code, weight_pct')
    .eq('exam_id', examId)
    .order('code')

  if (!domains) return []

  const results = await Promise.all(
    domains.map(async (domain) => {
      const { data: responses } = await supabase
        .from('user_responses')
        .select('is_correct, questions!inner(domain_id)')
        .eq('user_id', userId)
        .eq('questions.domain_id', domain.id)

      const total = responses?.length ?? 0
      const correct = responses?.filter((r) => r.is_correct).length ?? 0

      return {
        domainId: domain.id,
        domainName: domain.name,
        code: domain.code,
        weightPct: domain.weight_pct,
        correctPct: total > 0 ? Math.round((correct / total) * 100) : 0,
        totalAnswered: total,
      }
    })
  )

  return results
}

export async function getStudyStreak(userId: string) {
  const supabase = await createClient()

  const { data: responses } = await supabase
    .from('user_responses')
    .select('created_at')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })

  if (!responses || responses.length === 0) return 0

  const uniqueDays = [
    ...new Set(
      responses.map((r) =>
        new Date(r.created_at).toISOString().split('T')[0]
      )
    ),
  ].sort((a, b) => b.localeCompare(a))

  const today = new Date().toISOString().split('T')[0]
  let streak = 0
  let expectedDate = new Date(today)

  for (const day of uniqueDays) {
    const dayStr = expectedDate.toISOString().split('T')[0]
    if (day === dayStr) {
      streak++
      expectedDate.setDate(expectedDate.getDate() - 1)
    } else if (day < dayStr) {
      break
    }
  }

  return streak
}

export async function getQuestionsMastered(userId: string) {
  const supabase = await createClient()

  const { data: responses } = await supabase
    .from('user_responses')
    .select('question_id, repetitions')
    .eq('user_id', userId)
    .order('created_at', { ascending: false })

  if (!responses) return 0

  // Get the latest response per question
  const latestByQuestion = new Map<string, number>()
  for (const r of responses) {
    if (!latestByQuestion.has(r.question_id)) {
      latestByQuestion.set(r.question_id, r.repetitions)
    }
  }

  // Count questions with 3+ consecutive correct answers
  let mastered = 0
  for (const reps of latestByQuestion.values()) {
    if (reps >= 3) mastered++
  }

  return mastered
}

export async function getRecentSessions(userId: string, limit = 5) {
  const supabase = await createClient()

  const { data } = await supabase
    .from('quiz_sessions')
    .select('*, exams(name)')
    .eq('user_id', userId)
    .eq('is_completed', true)
    .order('created_at', { ascending: false })
    .limit(limit)

  return data ?? []
}
