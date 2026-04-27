# PostHog Event Inventory

> Source of truth for what PassTheCert sends to PostHog. **Update this file when adding/renaming/removing events.** Used by `LAUNCH_PLAN.md` C3 (PostHog dashboard) and the post-launch A2 (rewrite worst-performing questions).

## Setup

- Init: `app/providers.tsx` — `posthog-js` on the client. Identifies users via Supabase `userId` after sign-in (preserves anonymous → identified continuity).
- Server-side: `shared/lib/posthog-server.ts` exposes `captureServerEvent({ distinctId, event, properties })`. Non-blocking — analytics must never break a request.
- Env: `NEXT_PUBLIC_POSTHOG_KEY` (required to fire), `NEXT_PUBLIC_POSTHOG_HOST` (defaults to `https://eu.posthog.com`).

## Events

| Event | Side | Where it fires | `distinct_id` | Key properties |
|---|---|---|---|---|
| `$pageview` | client | every navigation | userId or anon | `$current_url` |
| `signup` | server | account created via email/password | email | `method` |
| `diagnostic_started` | client | user clicks "Start Diagnostic" | userId or anon | `question_count` |
| `diagnostic_completed` | server | 10/10 answered + email submitted | email | `overall_score`, `weakest_domain_id` |
| `lead_submitted` | server | email gate submitted (was `email_captured`) | email | `source` |
| `diagnostic_report_email_sent` | server | Resend email send succeeded | email | `source`, `resend_id` |
| `diagnostic_report_email_failed` | server | Resend email send failed | email | `source`, `error_name`, `error_message` |
| `paywall_viewed` | client | Paywall component rendered for a free user | userId | `source` (`quiz` / `full_exam` / `review_mistakes` / `domain_focus` / `other`) |
| `checkout_started` | server | `createCheckoutAndRedirect` action called | userId | (none) |
| `checkout_completed` | server | `checkout.session.completed` webhook | userId | `stripe_session_id` |
| `subscription_created` | server | `customer.subscription.created` webhook with status active/trialing | userId | `stripe_subscription_id`, `stripe_customer_id`, `status`, `trial_ends_at` |
| **`question_answered`** | server | `submitAnswer` after `user_responses` insert | userId | `question_id`, `is_correct`, `domain_id`, `session_id`, `mode`, `time_spent_secs` |
| `quiz_session_completed` | server | `completeSession` (was `study_session_completed`) | userId | `session_id`, `score_pct`, `correct_count`, `total_questions` |

## North-star metrics (LAUNCH_PLAN top of file)

| Metric | Computed from |
|---|---|
| % completion del diagnóstico (10/10) | `diagnostic_completed` / `diagnostic_started` |
| % email-to-checkout | `checkout_started` / `lead_submitted` |
| % first quiz session post-pago (en 24h) | `quiz_session_completed` within 24h of `subscription_created`, per user |
| Pagos reales en 72h post-launch | `subscription_created` count where `status=active` (or trialing) |

## A2 — data-driven question rewrite (post-launch)

The audit (`QUESTION_AUDIT.md` §7) defers rewriting batch 1 explanations until we have data. Use `question_answered`:

```sql
-- PostHog SQL (or HogQL): top 20 worst-performing questions
SELECT
  properties.question_id AS question_id,
  count() AS attempts,
  countIf(properties.is_correct = false) / count() AS pct_incorrect
FROM events
WHERE event = 'question_answered'
GROUP BY question_id
HAVING attempts >= 5
ORDER BY pct_incorrect DESC
LIMIT 20
```

Cross-reference each `question_id` against `supabase/seed.sql` + `supabase/migrations/003-007_*.sql` (batch 1) and rewrite using the template in `QUESTION_AUDIT.md` §8.

## Renames

If you ever need to rename an event again, **fire both names** for at least 1 release cycle so dashboards built on the old name don't go silently empty. Then drop the old name once dashboards are migrated. (Currently safe to rename in-place because no PostHog dashboards exist yet — C3 still pending.)
