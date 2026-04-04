'use server'

import { createAdminClient } from '@/shared/lib/supabase'
import { resend } from '@/shared/lib/resend'
import { diagnosticLeadSchema, checkAnswerSchema } from './schemas'
import { buildDiagnosticReportEmail } from './emails/diagnostic-report'
import type { DiagnosticLeadPayload, DomainScore, CheckAnswerResult } from './types'

interface SubmitLeadResult {
  success: boolean
  error?: string
}

export async function checkDiagnosticAnswer(
  questionId: string,
  selectedKey: string
): Promise<CheckAnswerResult> {
  const parsed = checkAnswerSchema.safeParse({ questionId, selectedKey })
  if (!parsed.success) {
    return { isCorrect: false, correctKey: '', explanation: 'Invalid input' }
  }

  const supabase = createAdminClient()

  const { data: question, error } = await supabase
    .from('questions')
    .select('correct_key, explanation')
    .eq('id', parsed.data.questionId)
    .single()

  if (error || !question) {
    return { isCorrect: false, correctKey: '', explanation: 'Question not found' }
  }

  return {
    isCorrect: parsed.data.selectedKey === question.correct_key,
    correctKey: question.correct_key,
    explanation: question.explanation,
  }
}

export async function submitDiagnosticLead(
  input: DiagnosticLeadPayload
): Promise<SubmitLeadResult> {
  const parsed = diagnosticLeadSchema.safeParse(input)
  if (!parsed.success) {
    return { success: false, error: parsed.error.issues[0]?.message ?? 'Invalid input' }
  }

  const { email, overallScore, domainScores, weakestDomainId } = parsed.data

  let supabase: ReturnType<typeof createAdminClient>
  try {
    supabase = createAdminClient()
  } catch {
    return { success: false, error: 'Server configuration error. Please try again later.' }
  }

  // Fetch domain names for the email
  const { data: domains } = await supabase
    .from('domains')
    .select('id, name, code')
    .order('code')

  if (!domains) {
    return { success: false, error: 'Failed to fetch domain data' }
  }

  const domainScoreDetails: DomainScore[] = domains
    .filter((d) => domainScores[d.id] !== undefined)
    .map((d) => ({
      domainId: d.id,
      domainName: d.name,
      domainCode: d.code,
      correct: Math.round((domainScores[d.id] / 100) * 5),
      total: 5,
      percentage: domainScores[d.id],
    }))

  const weakestDomain = domains.find((d) => d.id === weakestDomainId)

  // Upsert lead — update scores if email already exists (retake)
  const { error: upsertError } = await supabase
    .from('diagnostic_leads')
    .upsert(
      {
        email,
        overall_score: overallScore,
        domain_scores: domainScores,
        weakest_domain_id: weakestDomainId,
      },
      { onConflict: 'email' }
    )

  if (upsertError) {
    return { success: false, error: 'Failed to save your results. Please try again.' }
  }

  // Send email (non-blocking — lead is already saved)
  try {
    const html = buildDiagnosticReportEmail({
      overallScore,
      domainScores: domainScoreDetails,
      weakestDomainName: weakestDomain?.name ?? 'Unknown',
    })

    await resend().emails.send({
      from: 'PassTheCert <reports@passthecert.com>',
      to: email,
      subject: `Your Security+ Diagnostic: ${overallScore}% — Here's Your Study Plan`,
      html,
    })
  } catch {
    // Email failure is non-blocking — lead is already captured
  }

  return { success: true }
}
