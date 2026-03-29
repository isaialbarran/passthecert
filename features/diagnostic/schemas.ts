import { z } from 'zod'

export const diagnosticLeadSchema = z.object({
  email: z.string().trim().email('Please enter a valid email address'),
  overallScore: z.number().int().min(0).max(100),
  domainScores: z.record(z.string(), z.number().min(0).max(100)),
  weakestDomainId: z.string().uuid(),
})

export type DiagnosticLeadInput = z.infer<typeof diagnosticLeadSchema>
