'use client'

import type { JSX } from 'react'
import { useEffect, useRef } from 'react'
import { useRouter } from 'next/navigation'
import { checkIsPro } from '../actions'

const MAX_ATTEMPTS = 15 // 15 × 2s = 30 seconds

export function UpgradeSuccessBanner(): JSX.Element {
  const router = useRouter()
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null)

  useEffect(() => {
    let attempts = 0

    intervalRef.current = setInterval(async () => {
      attempts++
      if (attempts >= MAX_ATTEMPTS) {
        if (intervalRef.current) clearInterval(intervalRef.current)
        router.replace('/dashboard')
        return
      }
      const pro = await checkIsPro()
      if (pro) {
        if (intervalRef.current) clearInterval(intervalRef.current)
        router.replace('/dashboard')
        router.refresh()
      }
    }, 2000)

    return () => {
      if (intervalRef.current) clearInterval(intervalRef.current)
    }
  }, [router])

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
