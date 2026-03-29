'use server'

import { createAdminClient } from '@/shared/lib/supabase'
import { resend } from '@/shared/lib/resend'
import { diagnosticLeadSchema } from './schemas'
import { buildDiagnosticReportEmail } from './emails/diagnostic-report'
import type { DiagnosticLeadPayload, DomainScore } from './types'

interface SubmitLeadResult {
  success: boolean
  error?: string
}

export async function submitDiagnosticLead(
  input: DiagnosticLeadPayload
): Promise<SubmitLeadResult> {
  const parsed = diagnosticLeadSchema.safeParse(input)
  if (!parsed.success) {
    return { success: false, error: parsed.error.issues[0]?.message ?? 'Invalid input' }
  }

  const { email, overallScore, domainScores, weakestDomainId } = parsed.data

  const supabase = createAdminClient()

  // Fetch domain names for the email
  const { data: domains } = await supabase
    .from('domains')
    .select('id, name, code')
    .order('code')

  if (!domains) {
    return { success: false, error: 'Failed to fetch domain data' }
  }

  // Build domain score details for email
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

  // Insert lead
  const { error: insertError } = await supabase
    .from('diagnostic_leads')
    .insert({
      email,
      overall_score: overallScore,
      domain_scores: domainScores,
      weakest_domain_id: weakestDomainId,
    })

  if (insertError) {
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
