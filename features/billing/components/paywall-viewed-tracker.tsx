'use client'

import { useEffect } from 'react'
import { usePostHog } from 'posthog-js/react'

interface Props {
  source: 'quiz' | 'full_exam' | 'review_mistakes' | 'domain_focus' | 'other'
}

export function PaywallViewedTracker({ source }: Props): null {
  const posthog = usePostHog()
  useEffect(() => {
    posthog?.capture('paywall_viewed', { source })
  }, [posthog, source])
  return null
}
