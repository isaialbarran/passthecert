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

  // Get total question count per domain
  const { data: allQuestions } = await supabase
    .from('questions')
    .select('domain_id')
    .in(
      'domain_id',
      domains.map((d) => d.id)
    )

  const totalByDomain = new Map<string, number>()
  for (const q of allQuestions ?? []) {
    totalByDomain.set(q.domain_id, (totalByDomain.get(q.domain_id) ?? 0) + 1)
  }

  const results = await Promise.all(
    domains.map(async (domain) => {
      // Fetch all responses for this domain, ordered newest first
      const { data: responses } = await supabase
        .from('user_responses')
        .select('question_id, is_correct, created_at, questions!inner(domain_id)')
        .eq('user_id', userId)
        .eq('questions.domain_id', domain.id)
        .order('created_at', { ascending: false })

      // Keep only the latest answer per question
      const latestByQuestion = new Map<string, boolean>()
      for (const r of responses ?? []) {
        if (!latestByQuestion.has(r.question_id)) {
          latestByQuestion.set(r.question_id, r.is_correct)
        }
      }

      const uniqueSeen = latestByQuestion.size
      const correctLatest = [...latestByQuestion.values()].filter(Boolean).length
      const totalInDomain = totalByDomain.get(domain.id) ?? 0

      return {
        domainId: domain.id,
        domainName: domain.name,
        code: domain.code,
        weightPct: domain.weight_pct,
        correctPct: uniqueSeen > 0 ? Math.round((correctLatest / uniqueSeen) * 100) : 0,
        coveredPct: totalInDomain > 0 ? Math.round((uniqueSeen / totalInDomain) * 100) : 0,
        totalAnswered: uniqueSeen,
        totalInDomain,
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
  const expectedDate = new Date(today)

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

export async function getWrongAnswersCount(userId: string): Promise<number> {
  const supabase = await createClient()
  const { count, error } = await supabase
    .from('user_responses')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .eq('is_correct', false)
  if (error) console.error('[getWrongAnswersCount]', error)
  return count ?? 0
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
