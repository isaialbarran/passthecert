import { requireAuth } from '@/features/auth'
import { signOut } from '@/features/auth'
import { ThemeSwitcher } from '@/shared/components/ui/theme-switcher'
import Link from 'next/link'

export default async function AppLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const user = await requireAuth()

  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-border">
        <div className="mx-auto flex h-14 max-w-5xl items-center justify-between px-4">
          <Link
            href="/dashboard"
            className="font-heading text-lg font-extrabold text-foreground"
          >
            PassTheCert
          </Link>
          <div className="flex items-center gap-4">
            <ThemeSwitcher />
            <Link
              href="/settings"
              className="text-sm text-muted hover:text-foreground transition-colors"
            >
              Settings
            </Link>
            <span className="text-sm text-muted">
              {user.email}
            </span>
            <form action={signOut}>
              <button
                type="submit"
                className="text-sm text-muted hover:text-foreground transition-colors"
              >
                Sign out
              </button>
            </form>
          </div>
        </div>
      </header>
      <main className="mx-auto max-w-5xl px-4 py-8">{children}</main>
    </div>
  )
}
