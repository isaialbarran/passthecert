'use client'

import { useState, useEffect, useCallback, useTransition, startTransition } from 'react'
import { QuestionCard } from '@/shared/components/ui/question-card'
import { ExplanationPanel } from '@/shared/components/ui/explanation-panel'
import { checkDiagnosticAnswer } from '../actions'
import { DiagnosticResults } from './diagnostic-results'
import { EmailGate } from './email-gate'
import type {
  DiagnosticQuestion,
  DiagnosticAnswer,
  DiagnosticResult,
  DomainScore,
  CheckAnswerResult,
} from '../types'

type Phase = 'intro' | 'quiz' | 'results' | 'unlocked'

interface DiagnosticClientProps {
  questions: DiagnosticQuestion[]
}

const STORAGE_KEY = 'diagnostic_answers'

function loadSavedAnswers(): DiagnosticAnswer[] {
  if (typeof window === 'undefined') return []
  try {
    const saved = localStorage.getItem(STORAGE_KEY)
    return saved ? JSON.parse(saved) : []
  } catch {
    return []
  }
}

function saveAnswers(answers: DiagnosticAnswer[]): void {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(answers))
  } catch {
    // localStorage may be full or unavailable
  }
}

function clearSavedAnswers(): void {
  try {
    localStorage.removeItem(STORAGE_KEY)
  } catch {
    // noop
  }
}

function computeResult(
  answers: DiagnosticAnswer[],
  questions: DiagnosticQuestion[]
): DiagnosticResult {
  const domainMap = new Map<
    string,
    { name: string; code: string; correct: number; total: number }
  >()

  for (const q of questions) {
    if (!domainMap.has(q.domain_id)) {
      domainMap.set(q.domain_id, {
        name: q.domain_name,
        code: q.domain_code,
        correct: 0,
        total: 0,
      })
    }
    const entry = domainMap.get(q.domain_id)!
    entry.total += 1
  }

  let correctCount = 0
  for (const a of answers) {
    if (a.isCorrect) {
      correctCount += 1
      const entry = domainMap.get(a.domainId)
      if (entry) entry.correct += 1
    }
  }

  const domainScores: DomainScore[] = []
  let weakestId = ''
  let weakestName = ''
  let weakestPct = 101

  for (const [domainId, entry] of domainMap) {
    const percentage =
      entry.total > 0
        ? Math.round((entry.correct / entry.total) * 100)
        : 0
    domainScores.push({
      domainId,
      domainName: entry.name,
      domainCode: entry.code,
      correct: entry.correct,
      total: entry.total,
      percentage,
    })

    if (percentage < weakestPct) {
      weakestPct = percentage
      weakestId = domainId
      weakestName = entry.name
    }
  }

  domainScores.sort((a, b) => a.domainCode.localeCompare(b.domainCode))

  const overallScore = Math.round((correctCount / questions.length) * 100)

  return {
    overallScore,
    correctCount,
    totalQuestions: questions.length,
    domainScores,
    weakestDomainId: weakestId,
    weakestDomainName: weakestName,
  }
}

export function DiagnosticClient({
  questions,
}: DiagnosticClientProps): React.JSX.Element | null {
  const [phase, setPhase] = useState<Phase>('intro')
  const [answers, setAnswers] = useState<DiagnosticAnswer[]>([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selectedKey, setSelectedKey] = useState<string | null>(null)
  const [answerResult, setAnswerResult] = useState<CheckAnswerResult | null>(null)
  const [isChecking, startCheck] = useTransition()
  const [result, setResult] = useState<DiagnosticResult | null>(null)

  const isSubmitted = answerResult !== null

  // Restore from localStorage on mount
  useEffect(() => {
    const saved = loadSavedAnswers()
    if (saved.length > 0 && saved.length < questions.length) {
      startTransition(() => {
        setAnswers(saved)
        setCurrentIndex(saved.length)
        setPhase('quiz')
      })
    } else if (saved.length >= questions.length) {
      startTransition(() => {
        setAnswers(saved)
        setResult(computeResult(saved, questions))
        setPhase('results')
      })
    }
  }, [questions])

  const currentQuestion = questions[currentIndex] as
    | DiagnosticQuestion
    | undefined

  const handleSelect = useCallback(
    (key: string): void => {
      if (isSubmitted || isChecking) return
      setSelectedKey(key)
    },
    [isSubmitted, isChecking]
  )

  function handleSubmitAnswer(): void {
    if (!selectedKey || !currentQuestion || isSubmitted) return

    startCheck(async () => {
      const checkResult = await checkDiagnosticAnswer(
        currentQuestion.id,
        selectedKey
      )
      setAnswerResult(checkResult)

      const answer: DiagnosticAnswer = {
        questionId: currentQuestion.id,
        selectedKey,
        isCorrect: checkResult.isCorrect,
        domainId: currentQuestion.domain_id,
      }

      const newAnswers = [...answers, answer]
      setAnswers(newAnswers)
      saveAnswers(newAnswers)
    })
  }

  function handleNext(): void {
    const nextIndex = currentIndex + 1

    if (nextIndex >= questions.length) {
      const res = computeResult(answers, questions)
      setResult(res)
      setPhase('results')
      return
    }

    setCurrentIndex(nextIndex)
    setSelectedKey(null)
    setAnswerResult(null)
  }

  function handleStart(): void {
    setPhase('quiz')
  }

  function handleRestart(): void {
    clearSavedAnswers()
    setAnswers([])
    setCurrentIndex(0)
    setSelectedKey(null)
    setAnswerResult(null)
    setResult(null)
    setPhase('intro')
  }

  function handleUnlock(): void {
    clearSavedAnswers()
    setPhase('unlocked')
  }

  // --- Intro ---
  if (phase === 'intro') {
    return (
      <div className="mx-auto max-w-2xl py-20 text-center">
        <h1 className="font-heading text-4xl font-extrabold md:text-5xl">
          Security+ <span className="text-accent">Diagnostic</span>
        </h1>
        <p className="mx-auto mt-4 max-w-lg text-muted">
          25 questions across all 5 exam domains. Find out where you stand in
          about 5 minutes — no signup required.
        </p>

        <div className="mt-8 grid grid-cols-1 gap-4 text-left sm:grid-cols-3">
          <div className="rounded-lg border border-border bg-surface p-4">
            <p className="font-heading text-2xl font-extrabold text-accent">
              25
            </p>
            <p className="text-xs text-muted">Questions</p>
          </div>
          <div className="rounded-lg border border-border bg-surface p-4">
            <p className="font-heading text-2xl font-extrabold text-accent">
              5
            </p>
            <p className="text-xs text-muted">Domains Covered</p>
          </div>
          <div className="rounded-lg border border-border bg-surface p-4">
            <p className="font-heading text-2xl font-extrabold text-accent">
              ~5 min
            </p>
            <p className="text-xs text-muted">Estimated Time</p>
          </div>
        </div>

        <button
          onClick={handleStart}
          className="mt-8 rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
        >
          Start Diagnostic
        </button>
      </div>
    )
  }

  // --- Quiz ---
  if (phase === 'quiz' && currentQuestion) {
    return (
      <div className="mx-auto max-w-2xl space-y-6">
        {/* Progress */}
        <div className="flex items-center justify-between">
          <span className="text-sm text-muted">
            Question {currentIndex + 1} of {questions.length}
          </span>
          <div className="mx-4 h-2 flex-1 overflow-hidden rounded-full bg-surface">
            <div
              className="h-full rounded-full bg-accent transition-all duration-300"
              style={{
                width: `${((currentIndex + (isSubmitted ? 1 : 0)) / questions.length) * 100}%`,
              }}
            />
          </div>
        </div>

        {/* Domain tag */}
        <span className="inline-block rounded-md border border-border bg-surface px-2 py-1 text-xs text-muted">
          {currentQuestion.domain_code} — {currentQuestion.domain_name}
        </span>

        {/* Question stem */}
        <h2 className="font-heading text-xl font-extrabold leading-tight">
          {currentQuestion.stem}
        </h2>

        {/* Options */}
        <div className="space-y-3">
          {currentQuestion.options.map((option) => (
            <QuestionCard
              key={option.key}
              optionKey={option.key}
              text={option.text}
              isSelected={selectedKey === option.key}
              isSubmitted={isSubmitted}
              isCorrect={
                isSubmitted
                  ? option.key === answerResult?.correctKey
                  : undefined
              }
              isSelectedWrong={
                isSubmitted &&
                selectedKey === option.key &&
                !answerResult?.isCorrect
              }
              onClick={() => handleSelect(option.key)}
            />
          ))}
        </div>

        {/* Explanation */}
        {isSubmitted && answerResult && (
          <ExplanationPanel
            explanation={answerResult.explanation}
            isCorrect={answerResult.isCorrect}
          />
        )}

        {/* Actions */}
        <div className="flex justify-end gap-3">
          {!isSubmitted ? (
            <button
              onClick={handleSubmitAnswer}
              disabled={!selectedKey || isChecking}
              className="rounded-lg bg-accent px-6 py-3 text-sm font-medium text-[#060b06] transition-opacity disabled:opacity-40"
            >
              {isChecking ? 'Checking...' : 'Submit Answer'}
            </button>
          ) : (
            <button
              onClick={handleNext}
              className="rounded-lg bg-accent px-6 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
            >
              {currentIndex + 1 >= questions.length
                ? 'See Results'
                : 'Next Question'}
            </button>
          )}
        </div>
      </div>
    )
  }

  // --- Results (locked) ---
  if (phase === 'results' && result) {
    return (
      <div className="mx-auto max-w-2xl space-y-8 py-10">
        <DiagnosticResults result={result} isUnlocked={false} />
        <EmailGate result={result} onUnlock={handleUnlock} />
        <div className="text-center">
          <button
            onClick={handleRestart}
            className="text-sm text-muted underline transition-colors hover:text-foreground"
          >
            Retake Diagnostic
          </button>
        </div>
      </div>
    )
  }

  // --- Unlocked ---
  if (phase === 'unlocked' && result) {
    return (
      <div className="mx-auto max-w-2xl space-y-8 py-10">
        <DiagnosticResults result={result} isUnlocked={true} />
        <div className="text-center">
          <button
            onClick={handleRestart}
            className="text-sm text-muted underline transition-colors hover:text-foreground"
          >
            Retake Diagnostic
          </button>
        </div>
      </div>
    )
  }

  return null
}
