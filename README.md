# PassTheCert

Exam preparation platform for IT certifications. Spaced repetition (SM-2) + real exam-style questions. First cert: CompTIA Security+ (SY0-701).

## Stack

Next.js 16 (App Router) | TypeScript | Tailwind CSS | Supabase | Stripe | Resend | Vercel

## Setup

```bash
# Install dependencies
npm install

# Copy env template and fill in values
cp .env.example .env.local

# Start Supabase locally
npx supabase start

# Run migrations + seed
npx supabase db reset

# Start dev server
npm run dev
```

## Environment variables

See `.env.example` for the full list. Required:

- `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` — Supabase project
- `SUPABASE_SERVICE_ROLE_KEY` — server-only, never expose to client
- `STRIPE_SECRET_KEY` / `STRIPE_WEBHOOK_SECRET` / `NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY`
- `RESEND_API_KEY` — transactional emails
- `NEXT_PUBLIC_APP_URL` — `http://localhost:3000` in dev

## Project structure

```
app/                    # Routes only — no business logic
  (marketing)/          # Public: landing, diagnostic test
  (auth)/               # Login, signup, callback
  (app)/                # Protected: dashboard, quiz
features/               # Business logic by domain
  auth/                 # Supabase auth wrapper
  quiz/                 # Quiz engine, SM-2 algorithm
  diagnostic/           # Anonymous diagnostic test + lead capture
  progress/             # User stats, readiness score
  billing/              # Stripe checkout, webhooks
shared/
  lib/                  # Service clients (supabase.ts, stripe.ts, resend.ts)
  types/                # Global TS types
  components/ui/        # Design system
```

## Docs

- `INSTRUCTIONS.md` — MVP specification (source of truth)
- `CLAUDE.md` — AI agent instructions
- `AGENTS/` — Role prompts for the agent team
