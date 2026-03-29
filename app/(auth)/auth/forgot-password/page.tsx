'use client'

import { useActionState } from 'react'
import Link from 'next/link'
import { forgotPassword } from '@/features/auth/actions'
import type { AuthActionState } from '@/features/auth/actions'

export default function ForgotPasswordPage(): React.JSX.Element {
  const [state, formAction, pending] = useActionState<AuthActionState, FormData>(
    forgotPassword,
    null
  )

  if (state?.success) {
    return (
      <div className="w-full max-w-sm space-y-6 px-4 text-center">
        <div>
          <h1 className="font-heading text-3xl font-extrabold text-[#edfded]">
            Check your email
          </h1>
          <p className="mt-4 text-sm text-[#7ba87b]">
            If an account exists with that email, we sent you a password reset link.
          </p>
        </div>
        <Link
          href="/auth/login"
          className="inline-block text-sm text-[#4ade80] hover:underline"
        >
          Back to sign in
        </Link>
      </div>
    )
  }

  return (
    <div className="w-full max-w-sm space-y-6 px-4">
      <div className="text-center">
        <h1 className="font-heading text-3xl font-extrabold text-[#edfded]">
          Reset your password
        </h1>
        <p className="mt-2 text-sm text-[#7ba87b]">
          Enter your email and we&apos;ll send you a reset link
        </p>
      </div>

      <form action={formAction} className="space-y-4">
        <div>
          <label htmlFor="email" className="block text-sm font-medium text-[#edfded]">
            Email
          </label>
          <input
            id="email"
            name="email"
            type="email"
            autoComplete="email"
            required
            className="mt-1 block w-full rounded-lg border border-[rgba(74,222,128,0.2)] bg-[#0c140c] px-4 py-3 text-sm text-[#edfded] placeholder-[#7ba87b] focus:border-[#4ade80] focus:outline-none focus:ring-1 focus:ring-[#4ade80]"
            placeholder="you@example.com"
          />
        </div>

        {state?.error && (
          <p className="text-sm text-[#ef4444]">{state.error}</p>
        )}

        <button
          type="submit"
          disabled={pending}
          className="w-full rounded-lg bg-[#4ade80] px-4 py-3 text-sm font-medium text-[#060b06] transition-colors hover:bg-[#4ade80]/90 disabled:opacity-50"
        >
          {pending ? 'Sending...' : 'Send reset link'}
        </button>
      </form>

      <p className="text-center text-sm text-[#7ba87b]">
        <Link href="/auth/login" className="text-[#4ade80] hover:underline">
          Back to sign in
        </Link>
      </p>
    </div>
  )
}
