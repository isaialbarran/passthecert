'use client'

import { useState, useEffect, useRef } from 'react'

interface DiagnosticTimerProps {
  totalSeconds: number
  startedAt: number
  onExpire: () => void
}

export function DiagnosticTimer({
  totalSeconds,
  startedAt,
  onExpire,
}: DiagnosticTimerProps): React.JSX.Element {
  const onExpireRef = useRef(onExpire)
  useEffect(() => {
    onExpireRef.current = onExpire
  })

  // Lazy initializer computes remaining time at mount
  const [timeLeft, setTimeLeft] = useState<number>(() => {
    const elapsed = Math.floor((Date.now() - startedAt) / 1000)
    return Math.max(0, totalSeconds - elapsed)
  })

  useEffect(() => {
    const elapsed = Math.floor((Date.now() - startedAt) / 1000)
    const initial = Math.max(0, totalSeconds - elapsed)

    if (initial <= 0) {
      onExpireRef.current()
      return
    }

    const interval = setInterval(() => {
      const elapsed2 = Math.floor((Date.now() - startedAt) / 1000)
      const remaining = Math.max(0, totalSeconds - elapsed2)
      setTimeLeft(remaining)
      if (remaining <= 0) {
        clearInterval(interval)
        onExpireRef.current()
      }
    }, 1000)

    return () => clearInterval(interval)
  }, [startedAt, totalSeconds])

  const minutes = Math.floor(timeLeft / 60)
  const seconds = timeLeft % 60
  const isWarning = timeLeft <= 120
  const display = `${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`

  return (
    <div className="fixed right-4 top-4 z-50 rounded-lg border border-border bg-surface px-3 py-2 shadow-lg">
      <p className="text-xs text-muted">Time Remaining</p>
      <p
        className={`font-heading text-xl font-extrabold tabular-nums ${
          isWarning ? 'text-danger' : 'text-accent'
        }`}
      >
        {display}
      </p>
    </div>
  )
}
