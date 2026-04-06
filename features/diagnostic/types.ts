import type { QuestionOption } from '@/shared/types/database'

export interface DiagnosticQuestion {
  id: string
  stem: string
  options: QuestionOption[]
  difficulty: 'easy' | 'medium' | 'hard'
  domain_id: string
  domain_name: string
  domain_code: string
}

export interface CheckAnswerResult {
  isCorrect: boolean
}

export interface DiagnosticAnswer {
  questionId: string
  selectedKey: string
  isCorrect: boolean
  domainId: string
}

export interface DomainScore {
  domainId: string
  domainName: string
  domainCode: string
  correct: number
  total: number
  percentage: number
}

export interface DiagnosticResult {
  overallScore: number
  correctCount: number
  totalQuestions: number
  domainScores: DomainScore[]
  weakestDomainId: string
  weakestDomainName: string
}

export interface DomainScorePayload {
  percentage: number
  correct: number
  total: number
}

export interface DiagnosticLeadPayload {
  email: string
  overallScore: number
  domainScores: Record<string, DomainScorePayload>
  weakestDomainId: string
}
