import { z } from 'zod'

export const diagnosticLeadSchema = z.object({
  email: z.string().trim().email('Please enter a valid email address'),
  overallScore: z.number().int().min(0).max(100),
  domainScores: z.record(z.string(), z.object({
    percentage: z.number().min(0).max(100),
    correct: z.number().int().min(0),
    total: z.number().int().min(1),
  })),
  weakestDomainId: z.string().uuid(),
})

export const checkAnswerSchema = z.object({
  questionId: z.string().uuid(),
  selectedKey: z.string().min(1).max(2),
})

export type DiagnosticLeadInput = z.infer<typeof diagnosticLeadSchema>
