import { getUser } from '@/features/auth'
import { checkIsPro, createCheckoutSession } from '@/features/billing'
import Link from 'next/link'

const FEATURES = [
  'Preguntas ilimitadas',
  'Todos los modos de estudio (Rápido 10, Enfoque por dominio, Revisar errores)',
  'Simulación completa de examen (90 min, 90 preguntas)',
  'Plan de estudio personalizado basado en tu diagnóstico',
  'Puntuación de preparación y seguimiento de dominio',
] as const

export default async function PricingPage(): Promise<React.JSX.Element> {
  const user = await getUser()
  const isProUser = user ? await checkIsPro() : false

  return (
    <main className="mx-auto max-w-lg px-4 py-24">
      <h1 className="font-heading text-center text-4xl font-extrabold md:text-5xl">
        Un plan. Acceso <span className="text-accent">completo</span>.
      </h1>
      <p className="mt-4 text-center text-muted">
        Pasa tu certificación Security+ con práctica ilimitada y repetición
        espaciada inteligente.
      </p>

      <div className="mt-12 rounded-lg border border-accent/50 bg-surface p-8">
        <div className="flex items-baseline justify-between">
          <h2 className="font-heading text-xl font-extrabold text-accent">
            Pro
          </h2>
          <p className="font-heading text-4xl font-extrabold">
            &euro;29<span className="text-lg text-muted">/mes</span>
          </p>
        </div>

        <ul className="mt-6 space-y-3 text-sm">
          {FEATURES.map((feature) => (
            <li
              key={feature}
              className="flex items-center gap-2 text-foreground"
            >
              <span className="text-accent">&#10003;</span> {feature}
            </li>
          ))}
        </ul>

        <PricingCta isAuthenticated={!!user} isProUser={isProUser} />

        <p className="mt-3 text-center text-xs text-muted">
          Garantía de devolución de 7 días, sin preguntas
        </p>
      </div>
    </main>
  )
}

function PricingCta({
  isAuthenticated,
  isProUser,
}: {
  isAuthenticated: boolean
  isProUser: boolean
}): React.JSX.Element {
  if (isProUser) {
    return (
      <div className="mt-8 text-center">
        <p className="text-sm font-medium text-accent">
          Ya tienes una suscripción activa
        </p>
        <Link
          href="/dashboard"
          className="mt-3 inline-block text-sm text-muted underline underline-offset-4 transition-colors hover:text-foreground"
        >
          Ir al dashboard
        </Link>
      </div>
    )
  }

  if (!isAuthenticated) {
    return (
      <Link
        href="/auth/login?source=pricing&redirect=/dashboard"
        className="mt-8 block rounded-lg bg-accent py-3 text-center text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
      >
        Suscríbete — &euro;29/mes
      </Link>
    )
  }

  return (
    <form
      action={async (): Promise<void> => {
        'use server'
        await createCheckoutSession()
      }}
    >
      <button
        type="submit"
        className="mt-8 w-full cursor-pointer rounded-lg bg-accent py-3 text-center text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
      >
        Suscríbete — &euro;29/mes
      </button>
    </form>
  )
}
