export interface SM2Input {
  isCorrect: boolean
  quality: number // 0-5 (0-2: fail, 3-5: pass). For binary correct/wrong use: correct=4, wrong=1
  repetitions: number
  easeFactor: number // Default: 2.5, minimum: 1.3
  intervalDays: number // Default: 1
}

export interface SM2Output {
  repetitions: number
  easeFactor: number
  intervalDays: number
  nextReviewAt: Date
}

export type QuizMode =
  | 'random_10'
  | 'full_exam'
  | 'review_mistakes'
  | 'domain_focus'

export interface AnswerResult {
  isCorrect: boolean
  correctKey: string
  explanation: string
  questionIndex: number
  totalQuestions: number
}
