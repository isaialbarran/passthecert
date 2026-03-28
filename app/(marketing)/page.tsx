import Link from 'next/link'

export default function LandingPage() {
  return (
    <main>
      {/* Hero */}
      <section className="mx-auto max-w-3xl px-4 py-24 text-center">
        <h1 className="font-heading text-5xl font-extrabold leading-tight md:text-6xl">
          Pass Your{' '}
          <span className="text-accent">Security+</span>{' '}
          Certification
        </h1>
        <p className="mx-auto mt-6 max-w-xl text-lg text-muted">
          Practice with real exam-style questions. Our spaced repetition engine
          learns where you fail and repeats those questions until you&apos;re ready
          to pass.
        </p>
        <div className="mt-8 flex justify-center gap-4">
          <Link
            href="/auth/login"
            className="rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
          >
            Start Studying Free
          </Link>
        </div>
      </section>

      {/* Features */}
      <section className="border-t border-border py-20">
        <div className="mx-auto max-w-5xl px-4">
          <h2 className="font-heading text-center text-3xl font-extrabold">
            Built for Passing, Not Just Practicing
          </h2>
          <div className="mt-12 grid gap-8 md:grid-cols-3">
            <div className="rounded-lg border border-border bg-surface p-6">
              <h3 className="font-heading text-lg font-extrabold text-accent">
                Spaced Repetition
              </h3>
              <p className="mt-2 text-sm text-muted">
                Our SM-2 algorithm tracks your performance and resurfaces
                questions right before you forget them. Study smarter, not
                harder.
              </p>
            </div>
            <div className="rounded-lg border border-border bg-surface p-6">
              <h3 className="font-heading text-lg font-extrabold text-accent">
                Real Exam Format
              </h3>
              <p className="mt-2 text-sm text-muted">
                90-question timed exams that mirror the real CompTIA Security+
                (SY0-701). Know exactly what to expect on test day.
              </p>
            </div>
            <div className="rounded-lg border border-border bg-surface p-6">
              <h3 className="font-heading text-lg font-extrabold text-accent">
                Instant Feedback
              </h3>
              <p className="mt-2 text-sm text-muted">
                See explanations immediately after each answer. Understand why
                the correct answer is right and why yours was wrong.
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Pricing */}
      <section className="border-t border-border py-20">
        <div className="mx-auto max-w-3xl px-4">
          <h2 className="font-heading text-center text-3xl font-extrabold">
            Simple Pricing
          </h2>
          <p className="mt-2 text-center text-sm text-muted">
            Start free. Upgrade when you&apos;re serious about passing.
          </p>
          <div className="mt-12 grid gap-6 md:grid-cols-2">
            {/* Free */}
            <div className="rounded-lg border border-border bg-surface p-8">
              <h3 className="font-heading text-xl font-extrabold">Free</h3>
              <p className="mt-1 text-sm text-muted">Get started</p>
              <p className="mt-4 font-heading text-4xl font-extrabold">
                €0<span className="text-lg text-muted">/mo</span>
              </p>
              <ul className="mt-6 space-y-3 text-sm">
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> 20 questions per
                  day
                </li>
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> Quick 10 mode
                </li>
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> Review Mistakes
                </li>
                <li className="flex items-center gap-2 text-muted">
                  <span className="text-muted">&#10007;</span> Full Exam
                  simulation
                </li>
              </ul>
              <Link
                href="/auth/login"
                className="mt-8 block rounded-lg border border-border py-3 text-center text-sm font-medium text-foreground transition-colors hover:bg-accent/10"
              >
                Get Started
              </Link>
            </div>

            {/* Pro */}
            <div className="rounded-lg border border-accent/50 bg-surface p-8">
              <h3 className="font-heading text-xl font-extrabold text-accent">
                Pro
              </h3>
              <p className="mt-1 text-sm text-muted">Pass guaranteed</p>
              <p className="mt-4 font-heading text-4xl font-extrabold">
                €19<span className="text-lg text-muted">/mo</span>
              </p>
              <ul className="mt-6 space-y-3 text-sm">
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> Unlimited
                  questions
                </li>
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> All quiz modes
                </li>
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> Full Exam
                  simulation (90 min)
                </li>
                <li className="flex items-center gap-2 text-foreground">
                  <span className="text-accent">&#10003;</span> Domain-focused
                  practice
                </li>
              </ul>
              <Link
                href="/auth/login"
                className="mt-8 block rounded-lg bg-accent py-3 text-center text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
              >
                Start Pro
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* CTA */}
      <section className="border-t border-border py-20">
        <div className="mx-auto max-w-xl px-4 text-center">
          <h2 className="font-heading text-3xl font-extrabold">
            Stop guessing. Start passing.
          </h2>
          <p className="mt-4 text-sm text-muted">
            Join users already preparing for CompTIA Security+ with PassTheCert.
          </p>
          <Link
            href="/auth/login"
            className="mt-8 inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
          >
            Start Studying Now
          </Link>
        </div>
      </section>
    </main>
  )
}
