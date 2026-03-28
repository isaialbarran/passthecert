# PassTheCert — Project Specification (MVP)

> **For the AI Agent:** This document is your single source of truth. Follow it in order. Do not add features not listed here. Do not deviate from the stack. Speed and correctness over elegance.

---

## 1. Context & Vision

**PassTheCert** is a SaaS exam preparation platform. Think Anki meets a flight simulator — users practice with real exam-style questions, the system learns where they fail, and repeats those questions using spaced repetition until they're ready to pass.

**Demand is validated** via user interviews. The risk is not product-market fit — it's shipping too slowly or over-engineering too early.

**North star metric:** % of users who pass their certification after using PassTheCert. Every feature must serve this metric.

**First certification:** CompTIA Security+ (SY0-701). All question data must match this exam's current domains and format.

---

## 2. Target User

- IT professionals and students preparing for CompTIA Security+ certification.
- They have failed before, or want to pass on the first attempt.
- They are willing to pay before they have the cert — they need confidence, not content.

---

## 3. Tech Stack — Do Not Deviate

| Layer           | Technology                   | Reason                                             |
| --------------- | ---------------------------- | -------------------------------------------------- |
| Framework       | Next.js 15 (App Router)      | RSC + Server Actions, no separate API layer needed |
| Styling         | Tailwind CSS                 | Fast iteration                                     |
| Components      | Shadcn/UI                    | Pre-built accessible components                    |
| Data fetching   | TanStack Query (React Query) | Client-side caching and optimistic updates         |
| Database + Auth | Supabase (PostgreSQL)        | Auth, DB, RLS, and Storage in one                  |
| Payments        | Stripe                       | Subscriptions + webhooks                           |
| Email           | Resend                       | Transactional emails                               |
| Analytics       | PostHog                      | Retention tracking, funnel analysis                |
| Deployment      | Vercel                       | Zero-config deployment                             |

**Architecture:** Feature-based monolith. No microservices. No separate backend. No DDD overhead.

```
/
├── app/                        # Next.js routes only — no business logic here
│   ├── (marketing)/            # Public routes: landing, pricing
│   ├── (auth)/                 # Login, signup
│   └── (app)/                  # Protected routes: dashboard, quiz, progress
├── features/
│   ├── quiz/                   # Quiz engine, SM-2 algorithm, question display
│   ├── progress/               # User stats, domain mastery, readiness score
│   ├── billing/                # Stripe checkout, webhooks, subscription status
│   └── auth/                   # Supabase auth wrapper, middleware
├── shared/
│   ├── components/ui/          # Design system components
│   ├── lib/                    # supabase.ts, stripe.ts, resend.ts
│   └── types/                  # Global TypeScript types + Supabase generated types
├── supabase/
│   ├── migrations/             # Numbered SQL migration files
│   └── seed.sql                # Initial question bank (Security+)
└── middleware.ts               # Route protection using Supabase session
```

**Rule:** Each feature exposes a public API via its `index.ts`. No cross-feature imports from internal files.

---

## 4. Database Schema

Create these tables via Supabase migrations. Enable Row Level Security (RLS) on all tables from day one.

```sql
-- migrations/001_initial_schema.sql

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- ─── USERS ───────────────────────────────────────────────────────────────────
-- Extends Supabase auth.users with app-specific profile data
create table public.profiles (
  id            uuid references auth.users(id) on delete cascade primary key,
  email         text not null,
  full_name     text,
  avatar_url    text,
  -- Subscription
  stripe_customer_id    text unique,
  subscription_status   text default 'trialing', -- trialing | active | canceled | past_due
  subscription_tier     text default 'free',      -- free | pro
  trial_ends_at         timestamptz,
  -- Metadata
  created_at    timestamptz default now(),
  updated_at    timestamptz default now()
);

-- RLS: users can only read/write their own profile
alter table public.profiles enable row level security;
create policy "Users can view own profile" on public.profiles for select using (auth.uid() = id);
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id);

-- ─── EXAMS ───────────────────────────────────────────────────────────────────
-- Certification metadata (Security+, AWS, etc.)
create table public.exams (
  id            uuid default uuid_generate_v4() primary key,
  slug          text unique not null,         -- 'comptia-security-plus'
  name          text not null,                -- 'CompTIA Security+ (SY0-701)'
  vendor        text not null,                -- 'CompTIA'
  total_questions int default 90,
  pass_score    int default 750,              -- Out of 900
  duration_mins int default 90,
  is_active     boolean default true,
  created_at    timestamptz default now()
);

-- ─── DOMAINS ─────────────────────────────────────────────────────────────────
-- Exam domains (topics). Security+ has 5 domains.
create table public.domains (
  id            uuid default uuid_generate_v4() primary key,
  exam_id       uuid references public.exams(id) on delete cascade,
  name          text not null,                -- 'Threats, Attacks and Vulnerabilities'
  code          text not null,                -- '1.0'
  weight_pct    int not null,                 -- 24 (% of exam questions)
  created_at    timestamptz default now()
);

-- ─── QUESTIONS ───────────────────────────────────────────────────────────────
create table public.questions (
  id            uuid default uuid_generate_v4() primary key,
  exam_id       uuid references public.exams(id) on delete cascade,
  domain_id     uuid references public.domains(id) on delete set null,
  -- Content
  stem          text not null,                -- The question text
  options       jsonb not null,               -- [{"key":"A","text":"..."},{"key":"B","text":"..."}]
  correct_key   text not null,                -- 'A' | 'B' | 'C' | 'D'
  explanation   text not null,                -- Why the answer is correct (required, no exceptions)
  -- Metadata
  difficulty    text default 'medium',        -- easy | medium | hard
  question_type text default 'single',        -- single | multi (multiple correct answers)
  tags          text[] default '{}',          -- ['encryption', 'PKI', 'certificates']
  is_active     boolean default true,
  created_at    timestamptz default now()
);

-- Index for fast filtered queries
create index questions_exam_id_idx on public.questions(exam_id);
create index questions_domain_id_idx on public.questions(domain_id);

-- ─── USER RESPONSES ──────────────────────────────────────────────────────────
-- Every single answer attempt is recorded here. This is the SM-2 engine's input.
create table public.user_responses (
  id              uuid default uuid_generate_v4() primary key,
  user_id         uuid references public.profiles(id) on delete cascade,
  question_id     uuid references public.questions(id) on delete cascade,
  -- Answer data
  selected_key    text not null,
  is_correct      boolean not null,
  time_spent_secs int,                        -- Time to answer in seconds
  -- SM-2 spaced repetition fields
  repetitions     int default 0,              -- How many times answered correctly in a row
  ease_factor     float default 2.5,          -- SM-2 ease factor (min 1.3)
  interval_days   int default 1,              -- Days until next review
  next_review_at  timestamptz default now(),  -- When to show this question again
  -- Session context
  session_id      uuid,                       -- Groups answers from the same quiz session
  created_at      timestamptz default now()
);

-- RLS: users can only see their own responses
alter table public.user_responses enable row level security;
create policy "Users can view own responses" on public.user_responses for select using (auth.uid() = user_id);
create policy "Users can insert own responses" on public.user_responses for insert with check (auth.uid() = user_id);

-- Indexes for SM-2 queries
create index user_responses_user_question_idx on public.user_responses(user_id, question_id);
create index user_responses_next_review_idx on public.user_responses(user_id, next_review_at);

-- ─── QUIZ SESSIONS ───────────────────────────────────────────────────────────
-- Tracks each quiz attempt (Random 10, Full Exam, Review Mistakes)
create table public.quiz_sessions (
  id            uuid default uuid_generate_v4() primary key,
  user_id       uuid references public.profiles(id) on delete cascade,
  exam_id       uuid references public.exams(id),
  -- Session config
  mode          text not null,                -- 'random_10' | 'full_exam' | 'review_mistakes' | 'domain_focus'
  domain_id     uuid references public.domains(id), -- null = all domains
  -- Results (filled when session completes)
  total_questions int not null,
  correct_count   int default 0,
  score_pct       int,                        -- 0-100
  is_completed    boolean default false,
  completed_at    timestamptz,
  created_at      timestamptz default now()
);

alter table public.quiz_sessions enable row level security;
create policy "Users can manage own sessions" on public.quiz_sessions for all using (auth.uid() = user_id);

-- ─── READINESS SCORE ─────────────────────────────────────────────────────────
-- Denormalized for fast dashboard queries. Recalculated after each session.
create table public.readiness_scores (
  id              uuid default uuid_generate_v4() primary key,
  user_id         uuid references public.profiles(id) on delete cascade unique,
  exam_id         uuid references public.exams(id),
  overall_score   int default 0,              -- 0-100 "Ready to Pass" probability
  domain_scores   jsonb default '{}',         -- {"domain_id": score_pct, ...}
  questions_seen  int default 0,
  questions_mastered int default 0,           -- answered correctly 3+ times
  current_streak  int default 0,              -- consecutive study days
  last_activity_at timestamptz,
  updated_at      timestamptz default now()
);

alter table public.readiness_scores enable row level security;
create policy "Users can view own readiness" on public.readiness_scores for select using (auth.uid() = user_id);
```

---

## 5. SM-2 Algorithm (Spaced Repetition)

Implement this as pure TypeScript in `features/quiz/sm2.ts`. No external dependencies.

```typescript
// features/quiz/sm2.ts

export interface SM2Input {
  isCorrect: boolean;
  quality: number; // 0-5 (0-2: fail, 3-5: pass). For binary correct/wrong use: correct=4, wrong=1
  repetitions: number;
  easeFactor: number; // Default: 2.5, minimum: 1.3
  intervalDays: number; // Default: 1
}

export interface SM2Output {
  repetitions: number;
  easeFactor: number;
  intervalDays: number;
  nextReviewAt: Date;
}

export function calculateSM2(input: SM2Input): SM2Output {
  const quality = input.isCorrect ? 4 : 1;

  let { repetitions, easeFactor, intervalDays } = input;

  if (quality >= 3) {
    // Correct answer: advance the interval
    if (repetitions === 0) intervalDays = 1;
    else if (repetitions === 1) intervalDays = 6;
    else intervalDays = Math.round(intervalDays * easeFactor);

    repetitions += 1;
  } else {
    // Wrong answer: reset to beginning
    repetitions = 0;
    intervalDays = 1;
  }

  // Update ease factor
  easeFactor =
    easeFactor + (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
  easeFactor = Math.max(1.3, easeFactor);

  const nextReviewAt = new Date();
  nextReviewAt.setDate(nextReviewAt.getDate() + intervalDays);

  return { repetitions, easeFactor, intervalDays, nextReviewAt };
}
```

---

## 6. MVP Features (Phase 1) — Build in This Order

### 6.1 Auth (Supabase Google OAuth)

- Google OAuth only — no email/password forms to maintain
- On signup: create profile row + readiness_score row
- Middleware protects all `/app/*` routes

### 6.2 Quiz Engine

**Modes:**

- `random_10` — 10 random questions from the full bank
- `full_exam` — 90 questions, timed (90 minutes), simulates real exam
- `review_mistakes` — Only questions where `is_correct = false` in last 30 days
- `domain_focus` — Filter by specific domain (e.g., only "Cryptography")

**Question display:**

- One question at a time
- A, B, C, D options as clickable cards
- After selecting: lock all options, highlight correct in green, selected wrong in red
- Show full explanation immediately (not after finishing the quiz)
- "Next question" button to advance
- Progress indicator: "Question 4 of 10"
- Flag for review button (bookmarks question for later)

**On answer submit (Server Action):**

1. Save to `user_responses` with SM-2 fields calculated
2. Update `readiness_scores` (recalculate overall + domain scores)
3. Return next question

### 6.3 Progress Dashboard

Show at a glance:

- **Readiness Score** — Big number, 0-100%, with label: "Not Ready" / "Getting There" / "Ready to Pass"
- **Domain Mastery** — Bar or ring chart per Security+ domain showing % correct
- **Study Streak** — Consecutive days with at least one quiz
- **Questions Mastered** — Count of questions answered correctly 3+ times
- **Recent Sessions** — Last 5 quiz sessions with score and date
- **CTA:** "Start Practice" button → defaults to `random_10` mode

### 6.4 Pricing & Billing

- **Free tier:** 20 questions per day, no full exam mode
- **Pro (€19/month):** Unlimited questions, all modes, full exam simulation
- Stripe Checkout via Server Action
- Stripe webhook updates `subscription_status` in profiles table
- Gate features with `isPro()` helper from `features/billing/index.ts`

---

## 7. UI Design Direction

**Aesthetic:** Dark mode. Minimal. High-end. Think Linear or Vercel — not colorful EdTech.

**Color palette:**

```
Background:    #060b06  (near black, slight green tint)
Surface:       #0c140c
Border:        rgba(74,222,128,0.2)
Accent:        #4ade80  (green — "passed", "correct", "ready")
Text primary:  #edfded
Text muted:    #7ba87b
Danger:        #ef4444  (wrong answers only)
```

**Typography:**

- Headings: Bricolage Grotesque (800 weight)
- Body: DM Sans (300/400 weight)

**Key UI rules:**

- Correct answer: green border + green background tint
- Wrong answer: red border + red background tint
- Never show the correct answer before the user submits
- Explanation panel slides in below the options after submission
- No skeleton loaders — use Suspense boundaries with minimal fallbacks

---

## 8. Seed Data (First 5 Questions)

```sql
-- supabase/seed.sql
-- Run after migrations

-- Insert exam
insert into public.exams (slug, name, vendor, total_questions, pass_score, duration_mins)
values ('comptia-security-plus', 'CompTIA Security+ (SY0-701)', 'CompTIA', 90, 750, 90);

-- Insert domains (Security+ SY0-701 official domains)
insert into public.domains (exam_id, name, code, weight_pct)
select id, 'General Security Concepts', '1.0', 12 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Threats, Vulnerabilities, and Mitigations', '2.0', 22 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Security Architecture', '3.0', 18 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Security Operations', '4.0', 28 from public.exams where slug = 'comptia-security-plus'
union all
select id, 'Security Program Management and Oversight', '5.0', 20 from public.exams where slug = 'comptia-security-plus';

-- Insert sample questions (expand to 100+ before launch)
insert into public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
select
  e.id,
  d.id,
  'A security analyst discovers that an attacker has been intercepting traffic between a client and server without either party being aware. Which type of attack is this?',
  '[{"key":"A","text":"SQL Injection"},{"key":"B","text":"Man-in-the-Middle (MitM)"},{"key":"C","text":"Denial of Service"},{"key":"D","text":"Phishing"}]',
  'B',
  'A Man-in-the-Middle (MitM) attack occurs when an attacker secretly relays and possibly alters communications between two parties who believe they are communicating directly with each other. SQL Injection targets databases, DoS disrupts availability, and phishing targets users through deception.',
  'easy',
  array['network-security','attacks','mitm']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '2.0'

union all

select
  e.id,
  d.id,
  'Which cryptographic concept ensures that a sender cannot deny having sent a message?',
  '[{"key":"A","text":"Confidentiality"},{"key":"B","text":"Integrity"},{"key":"C","text":"Non-repudiation"},{"key":"D","text":"Availability"}]',
  'C',
  'Non-repudiation ensures that a party cannot deny the authenticity of their signature on a document or a message they sent. This is typically achieved through digital signatures using asymmetric cryptography. Confidentiality protects data from unauthorized access, integrity ensures data has not been altered, and availability ensures systems are accessible.',
  'medium',
  array['cryptography','pki','digital-signatures']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '1.0'

union all

select
  e.id,
  d.id,
  'An organization wants to ensure that only authorized devices can connect to their corporate network. Which technology should they implement?',
  '[{"key":"A","text":"VPN"},{"key":"B","text":"NAC (Network Access Control)"},{"key":"C","text":"IDS"},{"key":"D","text":"DLP"}]',
  'B',
  'Network Access Control (NAC) enforces security policy compliance on devices before granting network access. It can verify device health, patch levels, and identity before allowing connection. VPNs encrypt remote connections, IDS detects intrusions, and DLP prevents data exfiltration.',
  'medium',
  array['network-security','access-control','nac']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '3.0'

union all

select
  e.id,
  d.id,
  'What is the PRIMARY purpose of a Security Information and Event Management (SIEM) system?',
  '[{"key":"A","text":"To encrypt data at rest"},{"key":"B","text":"To collect, correlate, and analyze security logs from multiple sources"},{"key":"C","text":"To block malicious network traffic in real time"},{"key":"D","text":"To manage user passwords and access rights"}]',
  'B',
  'A SIEM system aggregates and correlates log data from multiple sources (firewalls, servers, applications) to provide real-time analysis of security alerts. It helps security teams detect threats, investigate incidents, and meet compliance requirements. It does not encrypt data, block traffic directly (that''s a firewall/IPS), or manage passwords (that''s an IAM system).',
  'easy',
  array['siem','monitoring','security-operations']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '4.0'

union all

select
  e.id,
  d.id,
  'A company''s security policy requires that users change their passwords every 90 days and cannot reuse their last 10 passwords. Which security concept does this BEST represent?',
  '[{"key":"A","text":"Account lockout policy"},{"key":"B","text":"Least privilege"},{"key":"C","text":"Password complexity requirements"},{"key":"D","text":"Password history and expiration policy"}]',
  'D',
  'Password history and expiration policies enforce regular password changes (expiration) and prevent reuse of recent passwords (history). Account lockout triggers after failed attempts, least privilege limits user permissions to the minimum necessary, and complexity requirements enforce character rules (uppercase, numbers, symbols).',
  'easy',
  array['identity-management','password-policy','access-control']
from public.exams e, public.domains d
where e.slug = 'comptia-security-plus' and d.code = '5.0';
```

---

## 9. Environment Variables

```bash
# .env.local (never commit — use .env.example as template)

# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
STRIPE_PRO_PRICE_ID=

# Resend
RESEND_API_KEY=

# PostHog
NEXT_PUBLIC_POSTHOG_KEY=
NEXT_PUBLIC_POSTHOG_HOST=https://eu.posthog.com

# App
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

---

## 10. Execution Order for the Agent

Execute in this exact order. Do not skip steps. Do not add features from later phases.

```
1. [ ] Run Supabase migrations (001_initial_schema.sql)
2. [ ] Run seed.sql
3. [ ] Configure Supabase Auth (Google OAuth provider)
4. [ ] Implement middleware.ts (route protection)
5. [ ] Build features/auth/ (getUser, requireAuth, signIn, signOut)
6. [ ] Build shared/lib/ (supabase.ts, stripe.ts, resend.ts clients)
7. [ ] Build features/quiz/sm2.ts (algorithm, pure TS, no deps)
8. [ ] Build features/quiz/ (getNextQuestion, submitAnswer actions)
9. [ ] Build app/(app)/quiz/[certId]/page.tsx (quiz UI)
10. [ ] Build features/progress/ (readiness score, domain mastery)
11. [ ] Build app/(app)/dashboard/page.tsx (progress dashboard)
12. [ ] Build features/billing/ (Stripe checkout + webhook)
13. [ ] Build app/(marketing)/page.tsx (landing page — already designed)
14. [ ] Deploy to Vercel (connect GitHub repo, add env vars)
15. [ ] Set up Stripe webhook endpoint in Vercel URL
```

---

## 11. What NOT to Build in Phase 1

- No admin dashboard
- No email/password auth (Google OAuth only)
- No mobile app
- No AI-generated questions
- No community features (forums, comments)
- No multiple languages
- No team/enterprise plans
- No API for third parties

---

## 12. Definition of Done (MVP)

The MVP is complete when:

- [ ] A user can sign in with Google
- [ ] A user can take a 10-question quiz and see explanations
- [ ] Wrong answers are tracked and surfaced in "Review Mistakes" mode
- [ ] The dashboard shows a readiness score and domain breakdown
- [ ] A user can pay €19/month via Stripe to unlock full access
- [ ] The app is live on passthecert.com via Vercel
- [ ] At least 5 real users have paid

**That's it. Ship it.**
