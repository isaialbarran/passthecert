# PassTheCert — Project Instructions

> Claude Code reads this file automatically. It is the source of truth for how to work in this codebase.

## Source of truth

- **`INSTRUCTIONS.md`** — MVP specification (features, schema, execution order). Read it before any task.
- **`AGENTS.md`** — Rules for subagents and role definitions.
- **`AGENTS/`** — Detailed system prompts per role (for use in Claude Projects or chat, not auto-read).

## Stack (do not deviate)

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 16 App Router + Server Actions |
| Language | TypeScript strict (no `any`, no `@ts-ignore`) |
| Styling | Tailwind CSS 4 |
| Components | Shadcn/UI (pending install) |
| Data fetching | TanStack Query (pending install) |
| Validation | Zod (pending install) |
| DB + Auth | Supabase (PostgreSQL + Google OAuth + RLS) |
| Payments | Stripe |
| Email | Resend |
| Testing | Playwright (pending install) |
| Deployment | Vercel |

## Next.js 16

This repo runs Next.js 16, which may have breaking changes vs. your training data. If unsure about a specific API (routing, Server Actions, middleware, etc.), consult `node_modules/next/dist/docs/` before using it. Don't read those docs preemptively — only when needed.

## Architecture

```
app/                    # Routes only — no business logic
  (marketing)/          # Public: landing, pricing
  (auth)/               # Login, callback
  (app)/                # Protected: dashboard, quiz
features/               # Business logic organized by domain
  auth/                 # Supabase auth wrapper
  quiz/                 # Quiz engine, SM-2, question display
  progress/             # User stats, readiness score
  billing/              # Stripe checkout, webhooks
shared/
  lib/                  # Service clients (supabase.ts, stripe.ts, resend.ts)
  types/                # Global TS types + Supabase generated types
  components/ui/        # Design system (Shadcn/UI)
AGENTS/                 # AI agent role prompts (reference docs)
```

**Rules:**
- Organize by feature, not by layer
- Each feature exposes a public API via `index.ts` — no cross-feature internal imports
- Server Actions for all mutations (verbs: `submitAnswer`, `createCheckout`)
- Queries as plain async functions in `features/[name]/queries.ts`
- Types co-located in `features/[name]/types.ts`
- Shared service clients in `shared/lib/` (singleton pattern)

## Code standards

- Explicit return types on all functions
- Validate all Server Action inputs with Zod before DB access
- Always handle Supabase errors: `const { data, error } = await supabase...`
- Never expose `SUPABASE_SERVICE_ROLE_KEY` to the client
- RLS enabled on every table — never bypass
- No `console.log` in production code
- No inline styles — Tailwind only
- No dependencies outside approved stack without explicit approval

## Design system

```
Background:    #060b06     Surface:     #0c140c
Border:        rgba(74,222,128,0.2)
Accent:        #4ade80     Danger:      #ef4444
Text primary:  #edfded     Text muted:  #7ba87b

Font heading:  Bricolage Grotesque (800)
Font body:     DM Sans (300/400)
```

Canonical values live in `app/globals.css`. Always verify there first.
