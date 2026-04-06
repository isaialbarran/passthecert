import Link from 'next/link'

export default function LandingPage(): React.JSX.Element {
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
        <div className="mt-8 flex flex-col items-center gap-3">
          <Link
            href="/diagnostic"
            className="rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
          >
            Test Your Knowledge — Free, No Signup
          </Link>
          <span className="text-xs text-muted">
            10 questions &middot; 10 minutes &middot; see where you stand
          </span>
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
        <div className="mx-auto max-w-lg px-4">
          <h2 className="font-heading text-center text-3xl font-extrabold">
            One Plan. Full Access.
          </h2>
          <p className="mt-2 text-center text-sm text-muted">
            Take the free diagnostic first. Pay only when you&apos;re ready to commit.
          </p>
          <div className="mt-12 rounded-lg border border-accent/50 bg-surface p-8">
            <div className="flex items-baseline justify-between">
              <h3 className="font-heading text-xl font-extrabold text-accent">
                Pro
              </h3>
              <p className="font-heading text-4xl font-extrabold">
                €29<span className="text-lg text-muted">/mo</span>
              </p>
            </div>
            <ul className="mt-6 space-y-3 text-sm">
              <li className="flex items-center gap-2 text-foreground">
                <span className="text-accent">&#10003;</span> Unlimited questions
              </li>
              <li className="flex items-center gap-2 text-foreground">
                <span className="text-accent">&#10003;</span> All quiz modes (Quick 10, Domain Focus, Review Mistakes)
              </li>
              <li className="flex items-center gap-2 text-foreground">
                <span className="text-accent">&#10003;</span> Full Exam simulation (90 min, 90 questions)
              </li>
              <li className="flex items-center gap-2 text-foreground">
                <span className="text-accent">&#10003;</span> Personalized study plan based on your diagnostic
              </li>
              <li className="flex items-center gap-2 text-foreground">
                <span className="text-accent">&#10003;</span> Readiness score &amp; domain mastery tracking
              </li>
            </ul>
            <Link
              href="/diagnostic"
              className="mt-8 block rounded-lg bg-accent py-3 text-center text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
            >
              Take the Free Diagnostic First
            </Link>
            <p className="mt-3 text-center text-xs text-muted">
              7-day money-back guarantee, no questions asked
            </p>
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
            Find out where you stand in 10 minutes — then let us build your study plan.
          </p>
          <Link
            href="/diagnostic"
            className="mt-8 inline-block rounded-lg bg-accent px-8 py-3 text-sm font-medium text-[#060b06] transition-opacity hover:opacity-90"
          >
            Take the Free Diagnostic
          </Link>
        </div>
      </section>
    </main>
  )
}
