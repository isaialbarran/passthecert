import Link from 'next/link'

export default function MarketingLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="min-h-screen bg-background">
      <header className="border-b border-border">
        <div className="mx-auto flex h-14 max-w-5xl items-center justify-between px-4">
          <Link
            href="/"
            className="font-heading text-lg font-extrabold text-foreground"
          >
            PassTheCert
          </Link>
          <Link
            href="/auth/login"
            className="rounded-lg bg-accent px-4 py-2 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
          >
            Sign In
          </Link>
        </div>
      </header>
      {children}
    </div>
  )
}
