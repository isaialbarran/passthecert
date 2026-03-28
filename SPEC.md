# PassTheCert — MVP Specification

> **Status:** Active

## 1. Product vision

PassTheCert is a SaaS exam preparation platform for IT certifications. It combines real exam-style questions with spaced repetition (SM-2) to learn where each user fails and repeat those questions until they're ready to pass. Think Anki meets a flight simulator — not a static question bank.

## 2. Target user

IT professionals and students preparing for CompTIA Security+ (SY0-701). They've either failed before or want to pass on the first attempt. They're willing to pay before they have the cert because they need confidence, not just content.

## 3. Core problem

Existing prep tools are either too passive (video courses) or too generic (random question banks with no memory). Users don't know where they're weak, and nothing adapts to fix it. PassTheCert solves this with a diagnostic entry point and a personalized study loop.

## 4. Solution overview

1. Visitor takes a free 25-question diagnostic test — no signup required
2. Results are gated behind email capture — visitor gets a full domain breakdown + personalized study estimate via email
3. CTA drives them to a 7-day free trial (full access, no credit card)
4. After trial: €19/month to continue
5. The app tracks every answer, calculates a readiness score, and surfaces weak areas automatically

## 5. Certification scope

MVP covers CompTIA Security+ (SY0-701) only. All 5 official domains:
- 1.0 General Security Concepts (12%)
- 2.0 Threats, Vulnerabilities, and Mitigations (22%)
- 3.0 Security Architecture (18%)
- 4.0 Security Operations (28%)
- 5.0 Security Program Management and Oversight (20%)

## 6. Feature list (MVP)

1. Diagnostic test (anonymous, lead magnet)
2. Google OAuth authentication
3. Quiz engine (random_10, full_exam, review_mistakes, domain_focus)
4. Progress dashboard (readiness score, domain mastery, streak)
5. Billing (€29/month via Stripe, 7-day money-back guarantee)
6. Diagnostic report email (Resend)

## 7. Tech stack

- Next.js 16 App Router + Server Actions
- TypeScript strict mode
- Tailwind CSS + Shadcn/UI
- Supabase (DB, Auth, RLS)
- TanStack Query (client-side data fetching)
- Zod (input validation)
- Stripe (subscriptions + webhooks)
- Resend (transactional email)
- PostHog (analytics)
- Vercel (deployment)

## 8. Data model

Key tables:
- `profiles` — extends Supabase auth, holds subscription status and trial dates
- `exams` — certification metadata
- `domains` — exam domains with weight percentages
- `questions` — question bank with options, correct answer, explanation
- `user_responses` — every answer attempt, SM-2 fields per question
- `quiz_sessions` — groups of answers per session with mode and score
- `readiness_scores` — denormalized per-user score, recalculated after each session
- `diagnostic_leads` — anonymous diagnostic results + email, tracks conversion

## 9. User flows

**Acquisition flow:**
Landing → "Test your knowledge free" → 25-question diagnostic (no login) → "See full results" → email capture → diagnostic report email → "Start 7-day free trial" → Google login → dashboard

**Study flow:**
Dashboard → Start Practice → quiz session (10 questions) → answer + see explanation → session summary → back to dashboard (readiness score updated)

**Conversion flow:**
Trial expires → paywall on quiz start → Stripe Checkout → active subscription → full access restored

## 10. Business model

- No free tier, no free trial
- Diagnostic test is the free value / lead magnet
- Pay to unlock: €29/month, charged immediately after diagnostic
- 7-day money-back guarantee (no questions asked) — displayed prominently as a trust signal
- Conversion goal: diagnostic email capture → payment on results page

## 11. Success metrics

- North star: % of users who pass their certification after using PassTheCert
- Supporting:
  - Diagnostic completion rate (started → email submitted)
  - Trial activation rate (email → account created)
  - Trial-to-paid conversion rate (now: diagnostic → payment rate)
  - Weekly active users (at least 1 session/week)
  - Average sessions per user before cancellation

## 12. MVP definition

The minimum set of features required for launch:
- Diagnostic test with email capture and report email
- Google OAuth + 7-day trial
- Quiz engine with SM-2 tracking
- Progress dashboard with readiness score
- Stripe billing (€29/month, 7-day money-back guarantee)
- Live on passthecert.com

## 13. Out of scope (post-MVP)

- Admin dashboard
- Email/password auth
- Mobile app
- AI-generated questions
- Community features (forums, comments)
- Multiple languages
- Team/enterprise plans
- Additional certifications (AWS, CISSP, etc.)
- API for third parties
