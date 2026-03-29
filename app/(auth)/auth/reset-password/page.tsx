'use client'

import { useActionState } from 'react'
import { resetPassword } from '@/features/auth/actions'
import type { AuthActionState } from '@/features/auth/actions'

export default function ResetPasswordPage(): React.JSX.Element {
  const [state, formAction, pending] = useActionState<AuthActionState, FormData>(
    resetPassword,
    null
  )

  return (
    <div className="w-full max-w-sm space-y-6 px-4">
      <div className="text-center">
        <h1 className="font-heading text-3xl font-extrabold text-[#edfded]">
          Set new password
        </h1>
        <p className="mt-2 text-sm text-[#7ba87b]">
          Enter your new password below
        </p>
      </div>

      <form action={formAction} className="space-y-4">
        <div>
          <label htmlFor="password" className="block text-sm font-medium text-[#edfded]">
            New password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            autoComplete="new-password"
            required
            minLength={8}
            className="mt-1 block w-full rounded-lg border border-[rgba(74,222,128,0.2)] bg-[#0c140c] px-4 py-3 text-sm text-[#edfded] placeholder-[#7ba87b] focus:border-[#4ade80] focus:outline-none focus:ring-1 focus:ring-[#4ade80]"
            placeholder="At least 8 characters"
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
          {pending ? 'Updating...' : 'Update password'}
        </button>
      </form>
    </div>
  )
}
