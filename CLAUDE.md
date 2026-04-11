# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Source of truth

- **`INSTRUCTIONS.md`** — MVP specification (features, schema, execution order). Read it before any task.
- **`AGENTS/`** — Agent role prompts and workflow docs. See `AGENTS/README.md` for the roster and how to invoke each role.

## Commands

```bash
npm run dev          # Start dev server (Next.js 16)
npm run build        # Production build
npm run lint         # ESLint (next/core-web-vitals + next/typescript)
npm start            # Run production build

# Supabase (requires supabase CLI)
npx supabase start   # Local Supabase instance
npx supabase db reset # Reset DB + run migrations + seed
npx supabase migration new <name>  # Create a new migration
```

No test runner is configured yet (Playwright is in the approved stack but not installed).

## Stack (do not deviate)

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 16 App Router + Server Actions |
| Language | TypeScript strict (no `any`, no `@ts-ignore`) |
| Styling | Tailwind CSS 4 |
| Components | Shadcn/UI (pending install) |
| Data fetching | TanStack Query (pending install) |
| Validation | Zod |
| DB + Auth | Supabase (PostgreSQL + Google OAuth + RLS) |
| Payments | Stripe |
| Email | Resend |
| Testing | Playwright (pending install) |
| Deployment | Vercel |

## Next.js 16

This repo runs Next.js 16, which may have breaking changes vs. your training data. If unsure about a specific API (routing, Server Actions, middleware, etc.), consult `node_modules/next/dist/docs/` before using it. Don't read those docs preemptively — only when needed.

### Breaking changes vs. Next.js 15

| What changed | Old (≤15) | New (16) |
|---|---|---|
| Route protection file | `middleware.ts` | `proxy.ts` |
| Exported function name | `export function middleware` | `export function proxy` |
| Runtime | `edge` (default) | `nodejs` (default, edge not supported in proxy) |
| Config flag | `skipMiddlewareUrlNormalize` | `skipProxyUrlNormalize` |

**Rule:** Never create `middleware.ts` in this repo. The file is `proxy.ts` at the project root. The exported function must be named `proxy`. `middleware.ts` still works if you need the `edge` runtime, but we use `nodejs` (proxy.ts).

### Supabase auth in proxy.ts

Use `createServerClient` from `@supabase/ssr` with `getAll`/`setAll` cookie methods. Always call `supabase.auth.getUser()` — never `getSession()` — for authorization decisions. Return `supabaseResponse` (not a fresh `NextResponse.next()`) to keep the session cookie alive.

## Architecture

```
app/                    # Routes only — no business logic
  (marketing)/          # Public: landing, pricing
  (auth)/               # Login, signup, callback
  (app)/                # Protected: dashboard, quiz
  api/webhooks/stripe/  # Stripe webhook handler
features/               # Business logic organized by domain
  auth/                 # Supabase auth wrapper (actions, queries, schemas)
  quiz/                 # Quiz engine, SM-2, question display
  progress/             # User stats, readiness score
  billing/              # Stripe checkout, webhooks
shared/
  lib/                  # Service clients (supabase.ts, stripe.ts, resend.ts)
  types/                # Global TS types + Supabase generated types (database.ts)
  components/ui/        # Design system (Shadcn/UI)
supabase/
  migrations/           # Numbered SQL migration files (001_initial_schema.sql, ...)
  seed.sql              # Initial question bank (Security+)
AGENTS/                 # AI agent role prompts (reference docs)
```

**Path alias:** `@/*` maps to the project root (configured in `tsconfig.json`). Use `@/features/...`, `@/shared/...`, etc.

**Rules:**
- Organize by feature, not by layer
- Each feature exposes a public API via `index.ts` — no cross-feature internal imports
- Server Actions for all mutations (verbs: `submitAnswer`, `createCheckout`)
- Queries as plain async functions in `features/[name]/queries.ts`
- Types co-located in `features/[name]/types.ts`
- Shared service clients in `shared/lib/` (singleton pattern)

## Supabase client pattern

Two clients in `shared/lib/supabase.ts`:
- `createBrowserClient()` — for client components
- `createClient()` — async, for Server Components and Server Actions (uses `cookies()`)

Env var for the anon key is `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY` (not the usual `NEXT_PUBLIC_SUPABASE_ANON_KEY`).

## Subagent rules (Task tool)

When a subagent is launched via the Task tool:
- It inherits `CLAUDE.md` as context automatically
- It must follow the architecture and code standards below
- It must read `INSTRUCTIONS.md` before any feature work
- It must never add dependencies outside the approved stack
- It must never bypass RLS or expose secrets
- `INSTRUCTIONS.md` is the constitution — no agent overrides it without founder approval

## Language

All user-facing text (UI labels, buttons, headings, error messages, email copy) must be in **English**. No Spanish, no mixed languages. This applies to every file in the codebase.

## Code standards

- Explicit return types on all functions
- Validate all Server Action inputs with Zod before DB access
- Always handle Supabase errors: `const { data, error } = await supabase...`
- Never expose `SUPABASE_SERVICE_ROLE_KEY` to the client
- RLS enabled on every table — never bypass
- No `console.log` in production code
- No inline styles — Tailwind only
- No dependencies outside approved stack without explicit approval
- Use comments sparingly — only comment complex code

## Design system

```
Background:    #060b06     Surface:     #0c140c
Border:        rgba(74,222,128,0.2)
Accent:        #4ade80     Danger:      #ef4444
Text primary:  #edfded     Text muted:  #7ba87b

Font heading:  Bricolage Grotesque (800) — var(--font-bricolage)
Font body:     DM Sans (300/400/500) — var(--font-dm-sans)
```

Canonical values live in `app/globals.css`. Always verify there first. Fonts are loaded in `app/layout.tsx` via `next/font/google`.
