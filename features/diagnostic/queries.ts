import { createAdminClient } from '@/shared/lib/supabase'
import type { DiagnosticQuestion } from './types'

export async function getDiagnosticQuestions(
  examSlug: string
): Promise<DiagnosticQuestion[]> {
  const supabase = createAdminClient()

  const { data: exam, error: examError } = await supabase
    .from('exams')
    .select('id')
    .eq('slug', examSlug)
    .single()

  if (examError || !exam) {
    throw new Error('Exam not found')
  }

  const { data: domains, error: domainsError } = await supabase
    .from('domains')
    .select('id, name, code, weight_pct')
    .eq('exam_id', exam.id)
    .order('code')

  if (domainsError || !domains) {
    throw new Error('Domains not found')
  }

  // Distribute 10 questions proportionally to domain weight
  const TOTAL_QUESTIONS = 10
  const quotas = distributeByWeight(
    domains.map((d) => d.weight_pct),
    TOTAL_QUESTIONS
  )

  const allQuestions: DiagnosticQuestion[] = []

  for (let i = 0; i < domains.length; i++) {
    const domain = domains[i]
    const quota = quotas[i]
    if (quota === 0) continue

    const { data: questions, error: questionsError } = await supabase
      .from('questions')
      .select('id, stem, options, difficulty, domain_id')
      .eq('exam_id', exam.id)
      .eq('domain_id', domain.id)
      .eq('is_active', true)
      .limit(quota)

    if (questionsError || !questions) continue

    for (const q of questions) {
      allQuestions.push({
        id: q.id,
        stem: q.stem,
        options: q.options as DiagnosticQuestion['options'],
        difficulty: q.difficulty as DiagnosticQuestion['difficulty'],
        domain_id: domain.id,
        domain_name: domain.name,
        domain_code: domain.code,
      })
    }
  }

  // Shuffle questions so domains aren't grouped together
  for (let i = allQuestions.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[allQuestions[i], allQuestions[j]] = [allQuestions[j], allQuestions[i]]
  }

  return allQuestions
}

interface DomainInfo {
  id: string
  name: string
  code: string
  weight_pct: number
}

export async function getDomains(examSlug: string): Promise<DomainInfo[]> {
  const supabase = createAdminClient()

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

/**
 * Largest-remainder method: distributes `total` slots proportionally
 * to the given weights, guaranteeing each weight > 0 gets at least 1 slot
 * and the sum equals exactly `total`.
 */
function distributeByWeight(weights: number[], total: number): number[] {
  const sum = weights.reduce((a, b) => a + b, 0)
  const exact = weights.map((w) => (w / sum) * total)
  const floors = exact.map((v) => Math.max(1, Math.floor(v)))

  let remaining = total - floors.reduce((a, b) => a + b, 0)
  const remainders = exact
    .map((v, i) => ({ i, r: v - floors[i] }))
    .sort((a, b) => b.r - a.r)

  for (const entry of remainders) {
    if (remaining <= 0) break
    floors[entry.i] += 1
    remaining -= 1
  }

  return floors
}
