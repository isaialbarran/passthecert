import type { JSX } from 'react'
import { createCheckoutAndRedirect } from '../actions'

export function Paywall(): JSX.Element {
  return (
    <div className="flex min-h-[60vh] items-center justify-center">
      <div className="w-full max-w-md rounded-lg border border-accent/40 bg-surface p-10 text-center">
        <svg
          className="mx-auto mb-6 h-12 w-12 text-accent"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth={1.5}
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M16.5 10.5V6.75a4.5 4.5 0 10-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 002.25-2.25v-6.75a2.25 2.25 0 00-2.25-2.25H6.75a2.25 2.25 0 00-2.25 2.25v6.75a2.25 2.25 0 002.25 2.25z"
          />
        </svg>
        <h2 className="font-heading text-2xl font-extrabold">
          Contenido exclusivo
        </h2>
        <p className="mx-auto mt-3 max-w-sm text-sm text-muted">
          Necesitas una suscripción para acceder a este contenido.
        </p>
        <form action={createCheckoutAndRedirect} className="mt-8">
          <button
            type="submit"
            className="w-full rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
          >
            Suscríbete — €29/mes
          </button>
        </form>
        <p className="mt-4 text-xs text-muted">
          Garantía de devolución de 7 días, sin preguntas
        </p>
      </div>
    </div>
  )
}
