'use server'

import { createClient } from '@/shared/lib/supabase'
import {
  getDomainMastery,
  getQuestionsMastered,
  getStudyStreak,
} from './queries'

export async function updateReadinessScore(userId: string, examId: string) {
  const supabase = await createClient()

  const domainMastery = await getDomainMastery(userId, examId)
  const questionsMastered = await getQuestionsMastered(userId)
  const streak = await getStudyStreak(userId)

  // Calculate overall score as weighted average of domain scores
  const domainScores: Record<string, number> = {}
  let weightedSum = 0
  let totalWeight = 0

  for (const domain of domainMastery) {
    domainScores[domain.domainId] = domain.correctPct
    weightedSum += domain.correctPct * domain.weightPct
    totalWeight += domain.weightPct
  }

  const overallScore =
    totalWeight > 0 ? Math.round(weightedSum / totalWeight) : 0

  // Count total unique questions seen
  const { count: questionsSeen } = await supabase
    .from('user_responses')
    .select('question_id', { count: 'exact', head: true })
    .eq('user_id', userId)

  await supabase
    .from('readiness_scores')
    .upsert(
      {
        user_id: userId,
        exam_id: examId,
        overall_score: overallScore,
        domain_scores: domainScores,
        questions_seen: questionsSeen ?? 0,
        questions_mastered: questionsMastered,
        current_streak: streak,
        last_activity_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      },
      { onConflict: 'user_id' }
    )

  return overallScore
}
