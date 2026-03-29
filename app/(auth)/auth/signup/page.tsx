'use client'

import { useActionState } from 'react'
import Link from 'next/link'
import { signUpWithEmail, signInWithGoogle } from '@/features/auth/actions'
import type { AuthActionState } from '@/features/auth/actions'

export default function SignUpPage(): React.JSX.Element {
  const [state, formAction, pending] = useActionState<AuthActionState, FormData>(
    signUpWithEmail,
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
            We sent you a confirmation link. Please check your email to verify your account.
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
          Create your account
        </h1>
        <p className="mt-2 text-sm text-[#7ba87b]">
          Start your certification prep journey
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

        <div>
          <label htmlFor="password" className="block text-sm font-medium text-[#edfded]">
            Password
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
          {pending ? 'Creating account...' : 'Create account'}
        </button>
      </form>

      <div className="relative">
        <div className="absolute inset-0 flex items-center">
          <div className="w-full border-t border-[rgba(74,222,128,0.2)]" />
        </div>
        <div className="relative flex justify-center text-xs">
          <span className="bg-[#060b06] px-2 text-[#7ba87b]">or</span>
        </div>
      </div>

      <form action={signInWithGoogle}>
        <button
          type="submit"
          className="flex w-full items-center justify-center gap-3 rounded-lg border border-[rgba(74,222,128,0.2)] bg-[#0c140c] px-4 py-3 text-sm font-medium text-[#edfded] transition-colors hover:bg-[#4ade80]/10"
        >
          <svg className="h-5 w-5" viewBox="0 0 24 24">
            <path
              d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 0 1-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"
              fill="#4285F4"
            />
            <path
              d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
              fill="#34A853"
            />
            <path
              d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
              fill="#FBBC05"
            />
            <path
              d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
              fill="#EA4335"
            />
          </svg>
          Continue with Google
        </button>
      </form>

      <p className="text-center text-sm text-[#7ba87b]">
        Already have an account?{' '}
        <Link href="/auth/login" className="text-[#4ade80] hover:underline">
          Sign in
        </Link>
      </p>
    </div>
  )
}
