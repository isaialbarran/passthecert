'use client'

import type { JSX } from 'react'
import { useCallback, useEffect, useRef, useState } from 'react'
import { useRouter } from 'next/navigation'
import { checkIsPro } from '../actions'

const MAX_ATTEMPTS = 30 // 30 × 2s = 60 seconds

export function UpgradeSuccessBanner(): JSX.Element {
  const router = useRouter()
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null)
  const [timedOut, setTimedOut] = useState(false)

  const startPolling = useCallback(() => {
    setTimedOut(false)
    let attempts = 0

    if (intervalRef.current) clearInterval(intervalRef.current)

    intervalRef.current = setInterval(async () => {
      attempts++
      if (attempts >= MAX_ATTEMPTS) {
        if (intervalRef.current) clearInterval(intervalRef.current)
        setTimedOut(true)
        return
      }
      try {
        const pro = await checkIsPro()
        if (pro) {
          if (intervalRef.current) clearInterval(intervalRef.current)
          router.replace('/dashboard')
          router.refresh()
        }
      } catch {
        // Network error — let the next interval attempt retry
      }
    }, 2000)
  }, [router])

  useEffect(() => {
    startPolling()
    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current)
    }
  }, [startPolling])

  if (timedOut) {
    return (
      <div className="rounded-lg border border-accent/40 bg-surface p-6 text-center">
        <h2 className="font-heading text-xl font-extrabold">
          Taking longer than expected
        </h2>
        <p className="mt-1 text-sm text-muted">
          Your payment was received but activation is still processing.
          Try refreshing — if the issue persists, contact support.
        </p>
        <button
          type="button"
          onClick={() => {
            router.refresh()
            startPolling()
          }}
          className="mt-4 rounded-lg bg-accent px-6 py-2 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
        >
          Retry
        </button>
      </div>
    )
  }

  return (
    <div className="rounded-lg border border-accent/40 bg-surface p-6 text-center">
      <div className="mx-auto mb-3 flex h-10 w-10 items-center justify-center rounded-full border border-accent/40">
        <svg
          className="h-5 w-5 animate-spin text-accent"
          fill="none"
          viewBox="0 0 24 24"
        >
          <circle
            className="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            strokeWidth="4"
          />
          <path
            className="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
          />
        </svg>
      </div>
      <h2 className="font-heading text-xl font-extrabold">Activating your access…</h2>
      <p className="mt-1 text-sm text-muted">
        Payment confirmed. Unlocking your account — this takes just a moment.
      </p>
    </div>
  )
}
