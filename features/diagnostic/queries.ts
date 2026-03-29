import { createClient } from '@/shared/lib/supabase'
import type { DiagnosticQuestion } from './types'

export async function getDiagnosticQuestions(
  examSlug: string
): Promise<DiagnosticQuestion[]> {
  const supabase = await createClient()

  // Get the exam
  const { data: exam, error: examError } = await supabase
    .from('exams')
    .select('id')
    .eq('slug', examSlug)
    .single()

  if (examError || !exam) {
    throw new Error('Exam not found')
  }

  // Get all domains for this exam
  const { data: domains, error: domainsError } = await supabase
    .from('domains')
    .select('id, name, code')
    .eq('exam_id', exam.id)
    .order('code')

  if (domainsError || !domains) {
    throw new Error('Domains not found')
  }

  // Fetch 5 random questions per domain
  const allQuestions: DiagnosticQuestion[] = []

  for (const domain of domains) {
    const { data: questions, error: questionsError } = await supabase
      .from('questions')
      .select('id, stem, options, correct_key, explanation, difficulty, domain_id')
      .eq('exam_id', exam.id)
      .eq('domain_id', domain.id)
      .eq('is_active', true)
      .limit(5)

    if (questionsError || !questions) continue

    for (const q of questions) {
      allQuestions.push({
        id: q.id,
        stem: q.stem,
        options: q.options as DiagnosticQuestion['options'],
        correct_key: q.correct_key,
        explanation: q.explanation,
        difficulty: q.difficulty as DiagnosticQuestion['difficulty'],
        domain_id: domain.id,
        domain_name: domain.name,
        domain_code: domain.code,
      })
    }
  }

  // Shuffle the questions
  for (let i = allQuestions.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[allQuestions[i], allQuestions[j]] = [allQuestions[j], allQuestions[i]]
  }

  return allQuestions
}

export async function getDomains(examSlug: string) {
  const supabase = await createClient()

  const { data: exam } = await supabase
    .from('exams')
    .select('id')
    .eq('slug', examSlug)
    .single()

  if (!exam) throw new Error('Exam not found')

  const { data: domains } = await supabase
    .from('domains')
    .select('id, name, code, weight_pct')
    .eq('exam_id', exam.id)
    .order('code')

  return domains ?? []
}
