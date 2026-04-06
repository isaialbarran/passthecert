import { Suspense } from 'react'
import { LoginForm } from './login-form'

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ next?: string }>
}): Promise<React.JSX.Element> {
  const { next } = await searchParams
  const safeNext = next && next.startsWith('/') && !next.startsWith('//') ? next : '/dashboard'

  return (
    <Suspense>
      <LoginForm next={safeNext} />
    </Suspense>
  )
}
