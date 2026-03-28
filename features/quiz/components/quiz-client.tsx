'use client'

import { useState, useTransition } from 'react'
import { submitAnswer, getNextQuestion } from '../actions'
import { QuestionCard } from './question-card'
import { ExplanationPanel } from './explanation-panel'
import type { Question } from '@/shared/types/database'
import type { AnswerResult } from '../types'
import Link from 'next/link'

interface QuizClientProps {
  sessionId: string
  initialQuestion: Question
  totalQuestions: number
}

export function QuizClient({
  sessionId,
  initialQuestion,
  totalQuestions,
}: QuizClientProps) {
  const [question, setQuestion] = useState<Question | null>(initialQuestion)
  const [selectedKey, setSelectedKey] = useState<string | null>(null)
  const [result, setResult] = useState<AnswerResult | null>(null)
  const [questionIndex, setQuestionIndex] = useState(1)
  const [isSubmitting, startSubmit] = useTransition()
  const [isLoadingNext, startLoadNext] = useTransition()
  const [sessionComplete, setSessionComplete] = useState(false)
  const [finalScore, setFinalScore] = useState<{
    correct: number
    total: number
  } | null>(null)

  const isSubmitted = result !== null

  function handleSelect(key: string) {
    if (isSubmitted || isSubmitting) return
    setSelectedKey(key)
  }

  function handleSubmit() {
    if (!selectedKey || !question || isSubmitted) return

    startSubmit(async () => {
      const answerResult = await submitAnswer(
        sessionId,
        question.id,
        selectedKey
      )
      setResult(answerResult)
    })
  }

  function handleNext() {
    startLoadNext(async () => {
      const nextQuestion = await getNextQuestion(sessionId)
      if (!nextQuestion) {
        setSessionComplete(true)
        setFinalScore({
          correct: result
            ? (result.isCorrect
                ? questionIndex
                : questionIndex - 1) +
              (result.isCorrect ? 0 : 0)
            : 0,
          total: totalQuestions,
        })
        return
      }
      setQuestion(nextQuestion)
      setSelectedKey(null)
      setResult(null)
      setQuestionIndex((i) => i + 1)
    })
  }

  if (sessionComplete) {
    return (
      <div className="flex flex-col items-center gap-6 py-20">
        <h2 className="font-heading text-3xl font-extrabold">
          Quiz Complete!
        </h2>
        {finalScore && (
          <p className="text-lg text-muted">
            You got{' '}
            <span className="text-accent font-medium">
              {result?.questionIndex ?? 0}
            </span>{' '}
            out of {totalQuestions} questions
          </p>
        )}
        <div className="flex gap-4">
          <Link
            href="/dashboard"
            className="rounded-lg border border-border bg-surface px-6 py-3 text-sm font-medium text-foreground transition-colors hover:bg-accent/10"
          >
            Back to Dashboard
          </Link>
        </div>
      </div>
    )
  }

  if (!question) return null

  return (
    <div className="mx-auto max-w-2xl space-y-6">
      {/* Progress */}
      <div className="flex items-center justify-between">
        <span className="text-sm text-muted">
          Question {questionIndex} of {totalQuestions}
        </span>
        <div className="h-2 flex-1 mx-4 rounded-full bg-surface overflow-hidden">
          <div
            className="h-full rounded-full bg-accent transition-all duration-300"
            style={{
              width: `${(questionIndex / totalQuestions) * 100}%`,
            }}
          />
        </div>
      </div>

      {/* Question stem */}
      <h2 className="font-heading text-xl font-extrabold leading-tight">
        {question.stem}
      </h2>

      {/* Options */}
      <div className="space-y-3">
        {question.options.map((option) => (
          <QuestionCard
            key={option.key}
            optionKey={option.key}
            text={option.text}
            isSelected={selectedKey === option.key}
            isSubmitted={isSubmitted}
            isCorrect={
              isSubmitted ? option.key === result?.correctKey : undefined
            }
            isSelectedWrong={
              isSubmitted &&
              selectedKey === option.key &&
              !result?.isCorrect
            }
            onClick={() => handleSelect(option.key)}
          />
        ))}
      </div>

      {/* Explanation */}
      {isSubmitted && result && (
        <ExplanationPanel
          explanation={result.explanation}
          isCorrect={result.isCorrect}
        />
      )}

      {/* Actions */}
      <div className="flex justify-end gap-3">
        {!isSubmitted ? (
          <button
            onClick={handleSubmit}
            disabled={!selectedKey || isSubmitting}
            className="rounded-lg bg-accent px-6 py-3 text-sm font-medium text-[#060b06] transition-opacity disabled:opacity-40"
          >
            {isSubmitting ? 'Submitting...' : 'Submit Answer'}
          </button>
        ) : (
          <button
            onClick={handleNext}
            disabled={isLoadingNext}
            className="rounded-lg bg-accent px-6 py-3 text-sm font-medium text-[#060b06] transition-opacity disabled:opacity-40"
          >
            {isLoadingNext ? 'Loading...' : 'Next Question'}
          </button>
        )}
      </div>
    </div>
  )
}
