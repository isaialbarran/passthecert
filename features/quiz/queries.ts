import { createClient } from '@/shared/lib/supabase'
import { requireAuth } from '@/features/auth'

export async function getQuizSession(sessionId: string) {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data } = await supabase
    .from('quiz_sessions')
    .select('*, exams(name, slug)')
    .eq('id', sessionId)
    .eq('user_id', user.id)
    .single()

  return data
}

export async function getSessionProgress(sessionId: string) {
  const user = await requireAuth()
  const supabase = await createClient()

  const { data: session } = await supabase
    .from('quiz_sessions')
    .select('total_questions, correct_count, is_completed')
    .eq('id', sessionId)
    .eq('user_id', user.id)
    .single()

  const { count } = await supabase
    .from('user_responses')
    .select('*', { count: 'exact', head: true })
    .eq('session_id', sessionId)

  return {
    answered: count ?? 0,
    total: session?.total_questions ?? 0,
    correctCount: session?.correct_count ?? 0,
    isCompleted: session?.is_completed ?? false,
  }
}
