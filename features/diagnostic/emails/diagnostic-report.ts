import { serverEnv } from '@/shared/lib/env'
import type { DomainScore } from '../types'

interface ReportEmailParams {
  overallScore: number
  domainScores: DomainScore[]
  weakestDomainName: string
}

function scoreColor(percentage: number): string {
  if (percentage >= 80) return '#4ade80'
  if (percentage >= 60) return '#facc15'
  return '#ef4444'
}

function studyEstimateWeeks(correctCount: number): number {
  const gap = Math.max(0, 90 - correctCount)
  return Math.ceil(gap / 10) || 1
}

export function buildDiagnosticReportEmail({
  overallScore,
  domainScores,
  weakestDomainName,
}: ReportEmailParams): string {
  const totalCorrect = domainScores.reduce((sum, d) => sum + d.correct, 0)
  const weeks = studyEstimateWeeks(totalCorrect)

  const domainRows = domainScores
    .map(
      (d) => `
      <tr>
        <td style="padding: 8px 12px; border-bottom: 1px solid #1a2e1a; color: #edfded; font-size: 14px;">
          ${d.domainCode} — ${d.domainName}
        </td>
        <td style="padding: 8px 12px; border-bottom: 1px solid #1a2e1a; text-align: center; color: ${scoreColor(d.percentage)}; font-weight: 600; font-size: 14px;">
          ${d.correct}/${d.total} (${d.percentage}%)
        </td>
      </tr>`
    )
    .join('')

  return `<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
<body style="margin: 0; padding: 0; background-color: #060b06; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;">
  <div style="max-width: 600px; margin: 0 auto; padding: 40px 20px;">

    <div style="text-align: center; margin-bottom: 32px;">
      <h1 style="color: #4ade80; font-size: 24px; margin: 0;">PassTheCert</h1>
      <p style="color: #7ba87b; font-size: 14px; margin-top: 4px;">Your Security+ Diagnostic Report</p>
    </div>

    <div style="background-color: #0c140c; border: 1px solid rgba(74,222,128,0.2); border-radius: 12px; padding: 32px; text-align: center; margin-bottom: 24px;">
      <p style="color: #7ba87b; font-size: 14px; margin: 0 0 8px;">Your Overall Score</p>
      <p style="color: ${scoreColor(overallScore)}; font-size: 56px; font-weight: 800; margin: 0; line-height: 1;">
        ${overallScore}%
      </p>
      <p style="color: #7ba87b; font-size: 13px; margin-top: 8px;">
        ${overallScore >= 80 ? 'Great foundation — you\'re close to exam-ready!' : overallScore >= 60 ? 'Solid start — some domains need more work.' : 'You\'ve identified key gaps — let\'s close them.'}
      </p>
    </div>

    <div style="background-color: #0c140c; border: 1px solid rgba(74,222,128,0.2); border-radius: 12px; padding: 24px; margin-bottom: 24px;">
      <h2 style="color: #edfded; font-size: 16px; margin: 0 0 16px;">Domain Breakdown</h2>
      <table style="width: 100%; border-collapse: collapse;">
        <thead>
          <tr>
            <th style="padding: 8px 12px; border-bottom: 1px solid rgba(74,222,128,0.3); text-align: left; color: #7ba87b; font-size: 12px; text-transform: uppercase;">Domain</th>
            <th style="padding: 8px 12px; border-bottom: 1px solid rgba(74,222,128,0.3); text-align: center; color: #7ba87b; font-size: 12px; text-transform: uppercase;">Score</th>
          </tr>
        </thead>
        <tbody>
          ${domainRows}
        </tbody>
      </table>
    </div>

    <div style="background-color: #0c140c; border: 1px solid rgba(239,68,68,0.3); border-radius: 12px; padding: 24px; margin-bottom: 24px;">
      <h2 style="color: #ef4444; font-size: 16px; margin: 0 0 8px;">Focus Area</h2>
      <p style="color: #edfded; font-size: 14px; margin: 0;">
        Your weakest domain is <strong style="color: #ef4444;">${weakestDomainName}</strong>. We recommend starting your study plan here.
      </p>
    </div>

    <div style="background-color: #0c140c; border: 1px solid rgba(74,222,128,0.2); border-radius: 12px; padding: 24px; margin-bottom: 32px;">
      <h2 style="color: #edfded; font-size: 16px; margin: 0 0 8px;">Estimated Study Time</h2>
      <p style="color: #4ade80; font-size: 28px; font-weight: 700; margin: 0;">
        ~${weeks} week${weeks !== 1 ? 's' : ''}
      </p>
      <p style="color: #7ba87b; font-size: 13px; margin-top: 4px;">
        Based on your current score, with consistent daily practice.
      </p>
    </div>

    <div style="text-align: center; margin-bottom: 32px;">
      <a href="${serverEnv().NEXT_PUBLIC_APP_URL}/auth/login?source=diagnostic" style="display: inline-block; background-color: #4ade80; color: #060b06; text-decoration: none; padding: 14px 32px; border-radius: 8px; font-size: 14px; font-weight: 600;">
        Start Your Study Plan
      </a>
      <p style="color: #7ba87b; font-size: 12px; margin-top: 12px;">
        Personalized spaced repetition &middot; All 5 domains &middot; Exam simulation
      </p>
    </div>

    <div style="text-align: center; border-top: 1px solid rgba(74,222,128,0.1); padding-top: 20px;">
      <p style="color: #7ba87b; font-size: 11px; margin: 0;">
        PassTheCert &middot; CompTIA Security+ Exam Prep
      </p>
    </div>

  </div>
</body>
</html>`
}
