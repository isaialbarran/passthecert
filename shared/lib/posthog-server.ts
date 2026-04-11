interface CapturePayload {
  distinctId: string
  event: string
  properties?: Record<string, unknown>
}

/**
 * Fire a PostHog event from Server Actions or Route Handlers.
 * Non-blocking — analytics must never break core functionality.
 */
export async function captureServerEvent({
  distinctId,
  event,
  properties,
}: CapturePayload): Promise<void> {
  const key = process.env.NEXT_PUBLIC_POSTHOG_KEY
  const host = process.env.NEXT_PUBLIC_POSTHOG_HOST ?? 'https://eu.posthog.com'

  if (!key) return

  try {
    await fetch(`${host}/capture/`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        api_key: key,
        event,
        distinct_id: distinctId,
        properties: properties ?? {},
      }),
    })
  } catch {
    // Intentionally swallowed — analytics should never break the request
  }
}
