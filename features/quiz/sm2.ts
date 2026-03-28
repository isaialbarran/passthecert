import type { SM2Input, SM2Output } from './types'

export function calculateSM2(input: SM2Input): SM2Output {
  const quality = input.isCorrect ? 4 : 1

  let { repetitions, easeFactor, intervalDays } = input

  if (quality >= 3) {
    // Correct answer: advance the interval
    if (repetitions === 0) intervalDays = 1
    else if (repetitions === 1) intervalDays = 6
    else intervalDays = Math.round(intervalDays * easeFactor)

    repetitions += 1
  } else {
    // Wrong answer: reset to beginning
    repetitions = 0
    intervalDays = 1
  }

  // Update ease factor
  easeFactor =
    easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02))
  easeFactor = Math.max(1.3, easeFactor)

  const nextReviewAt = new Date()
  nextReviewAt.setDate(nextReviewAt.getDate() + intervalDays)

  return { repetitions, easeFactor, intervalDays, nextReviewAt }
}
