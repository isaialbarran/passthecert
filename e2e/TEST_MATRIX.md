# E2E Test Matrix — PassTheCert

> Source of truth for automated test coverage. Update status as tests are implemented.

## Summary

| Workflow | Done | Pending | Total | Coverage |
|----------|------|---------|-------|----------|
| Diagnostic Quiz | 6 | 4 | 10 | 60% |
| Authentication | 1 | 7 | 8 | 13% |
| Quiz Engine | 0 | 14 | 14 | 0% |
| Dashboard & Progress | 4 | 6 | 10 | 40% |
| Billing & Subscription | 0 | 8 | 8 | 0% |
| Cross-cutting | 0 | 4 | 4 | 0% |
| **Total** | **11** | **43** | **54** | **20%** |

### Priority definitions

- **P0** — Core revenue path. If broken, users can't study or pay. Block deploys.
- **P1** — Important flows (auth, progress, free limits). Implement soon.
- **P2** — Edge cases, responsive, polish. Nice to have.

---

## 1. Diagnostic Quiz (public, no auth)

**Spec file:** `e2e/diagnostic.spec.ts`

| ID | Test Case | Priority | Status | Notes |
|----|-----------|----------|--------|-------|
| DIAG-01 | Intro shows 10 questions, 5 domains, 10 min | P0 | done | TC-01 |
| DIAG-02 | Timer appears and starts near 10:00 on quiz start | P1 | done | TC-02 |
| DIAG-03 | Answering question advances to next without feedback | P0 | done | TC-03 |
| DIAG-04 | Progress bar fills proportionally as questions are answered | P1 | done | TC-04 |
| DIAG-05 | Page refresh resumes quiz at correct question | P0 | done | TC-05 |
| DIAG-06 | Retake clears localStorage and returns to intro | P1 | done | TC-06 |
| DIAG-07 | Completing all 10 questions shows results screen with score | P0 | **pending** | End-to-end completion |
| DIAG-08 | Email gate appears on "See Full Results" click | P0 | **pending** | Lead capture CTA |
| DIAG-09 | Submitting email via gate calls `submitDiagnosticLead` successfully | P0 | **pending** | Server action integration |
| DIAG-10 | Domain breakdown shows 5 domains with percentages | P1 | **pending** | Results detail view |

---

## 2. Authentication

**Spec file:** `e2e/auth.spec.ts` (to create)

| ID | Test Case | Priority | Status | Notes |
|----|-----------|----------|--------|-------|
| AUTH-01 | Unauthenticated user visiting /dashboard redirects to /auth/login | P0 | done | In `dashboard-greeting.spec.ts` TC-11 |
| AUTH-02 | Login page renders email/password form and Google button | P1 | **pending** | Smoke test |
| AUTH-03 | Email/password login with valid credentials redirects to /dashboard | P0 | **pending** | Uses TEST_USER env vars |
| AUTH-04 | Email/password login with invalid credentials shows error message | P1 | **pending** | |
| AUTH-05 | Sign out clears session and redirects to / | P0 | **pending** | |
| AUTH-06 | Login preserves `?next=` param and redirects after auth | P1 | **pending** | e.g. `?next=/quiz/comptia-security-plus` |
| AUTH-07 | Forgot password page renders and accepts email submission | P2 | **pending** | |
| AUTH-08 | OAuth callback with invalid code shows error, does not crash | P2 | **pending** | |

---

## 3. Quiz Engine (authenticated)

**Spec file:** `e2e/quiz.spec.ts` (to create)

| ID | Test Case | Priority | Status | Notes |
|----|-----------|----------|--------|-------|
| QUIZ-01 | Start `random_10` session — first question renders with 4 options | P0 | **pending** | `startQuizSession` action |
| QUIZ-02 | Selecting an answer and submitting shows correct/incorrect feedback | P0 | **pending** | `submitAnswer` action, green/red highlight |
| QUIZ-03 | Explanation text appears after answer submission | P0 | **pending** | |
| QUIZ-04 | "Next Question" advances to next question after feedback | P0 | **pending** | `getNextQuestion` action |
| QUIZ-05 | Question counter increments (e.g. "2 of 10") | P1 | **pending** | |
| QUIZ-06 | Completing all questions in session shows results with score % | P0 | **pending** | `completeSession` action |
| QUIZ-07 | Results screen shows correct count and total | P1 | **pending** | |
| QUIZ-08 | Starting a new session after completing one works | P1 | **pending** | |
| QUIZ-09 | Free user hitting 20 daily question limit sees paywall/error | P0 | **pending** | `getDailyQuestionCount` check |
| QUIZ-10 | Pro user can start `full_exam` mode (90 questions) | P0 | **pending** | Requires pro test user |
| QUIZ-11 | Free user attempting `full_exam` mode is blocked | P0 | **pending** | Paywall enforcement |
| QUIZ-12 | `review_mistakes` mode only shows previously wrong questions | P1 | **pending** | Requires prior wrong answers |
| QUIZ-13 | `domain_focus` mode only shows questions from selected domain | P1 | **pending** | |
| QUIZ-14 | SM-2 fields persist — answering same question again uses updated interval | P2 | **pending** | Verify `user_responses` SM-2 state |

---

## 4. Dashboard & Progress (authenticated)

**Spec file:** `e2e/dashboard-greeting.spec.ts` (existing) + `e2e/dashboard.spec.ts` (to create for extended coverage)

| ID | Test Case | Priority | Status | Notes |
|----|-----------|----------|--------|-------|
| DASH-01 | Greeting shows "Good morning/afternoon/evening" with no undefined/null | P1 | done | TC-01 |
| DASH-02 | Readiness, streak, and mastered stats are visible | P0 | done | TC-04 |
| DASH-03 | Stats show valid numeric values (no NaN, no empty) | P1 | done | TC-09 |
| DASH-04 | Readiness label is one of: Not Ready, Getting There, Ready to Pass | P1 | done | TC-10 |
| DASH-05 | Review Mistakes button appears only when user has wrong answers | P1 | done | TC-05/TC-06 (conditional check) |
| DASH-06 | Domain mastery section shows 5 domains with percentage bars | P0 | **pending** | `getDomainMastery` query |
| DASH-07 | Recent sessions list shows up to 5 completed sessions | P1 | **pending** | `getRecentSessions` query |
| DASH-08 | Readiness score updates after completing a quiz session | P0 | **pending** | Cross-flow: quiz → dashboard |
| DASH-09 | Study streak increments after answering at least 1 question today | P1 | **pending** | `getStudyStreak` query |
| DASH-10 | Free user sees upgrade banner; pro user does not | P0 | **pending** | Subscription-aware UI |

---

## 5. Billing & Subscription

**Spec file:** `e2e/billing.spec.ts` (to create)

> Note: Stripe Checkout and webhooks require test-mode keys and cannot be fully E2E tested without Stripe CLI or mock webhooks. Tests marked with (mock) need a webhook simulation strategy.

| ID | Test Case | Priority | Status | Notes |
|----|-----------|----------|--------|-------|
| BILL-01 | Free user sees "Upgrade to Pro" CTA on dashboard | P0 | **pending** | Same as DASH-10 |
| BILL-02 | Clicking upgrade calls `createCheckoutSession` and redirects to Stripe | P0 | **pending** | Verify redirect URL starts with `https://checkout.stripe.com` |
| BILL-03 | `checkout.session.completed` webhook updates profile to pro | P0 | **pending** | (mock) Use Stripe CLI `stripe trigger` or direct API call |
| BILL-04 | After webhook, dashboard no longer shows upgrade banner | P0 | **pending** | Depends on BILL-03 |
| BILL-05 | Pro user can access "Manage Subscription" on settings page | P1 | **pending** | `createPortalSession` action |
| BILL-06 | `customer.subscription.deleted` webhook downgrades to free | P1 | **pending** | (mock) Profile reverts to free tier |
| BILL-07 | `invoice.payment_failed` webhook sets status to past_due | P2 | **pending** | (mock) |
| BILL-08 | Past-due user still has access but sees warning | P2 | **pending** | Graceful degradation |

---

## 6. Cross-cutting

**Spec file:** `e2e/cross-cutting.spec.ts` (to create)

| ID | Test Case | Priority | Status | Notes |
|----|-----------|----------|--------|-------|
| CROSS-01 | All protected routes redirect to /auth/login when unauthenticated | P0 | **pending** | /dashboard, /quiz/*, /settings |
| CROSS-02 | Landing page (/) loads without errors for anonymous users | P0 | **pending** | Smoke test |
| CROSS-03 | 404 page renders for unknown routes | P2 | **pending** | |
| CROSS-04 | No console errors on key pages (landing, dashboard, quiz) | P1 | **pending** | Use `page.on('console')` to catch errors |

---

## Test Infrastructure Notes

### Existing setup
- **Playwright config:** `playwright.config.ts` — Chromium only, sequential (workers: 1)
- **Base URL:** `http://localhost:3000`
- **Web server:** `npm run dev` auto-started
- **Scripts:** `npm run test:e2e`, `test:e2e:ui`, `test:e2e:headed`, `test:e2e:report`

### Required env vars
```
TEST_USER_EMAIL=       # Email/password test account (free tier)
TEST_USER_PASSWORD=    # Password for test account
TEST_PRO_EMAIL=        # Pro tier test account (for QUIZ-10, DASH-10, BILL-05)
TEST_PRO_PASSWORD=     # Password for pro test account
```

### Implementation order (recommended)
1. **AUTH** — login helper is a dependency for all authenticated tests
2. **QUIZ** — core product, highest business impact
3. **DASH** — validates quiz results propagate correctly
4. **DIAG** — expand existing coverage (email gate, completion)
5. **BILLING** — requires Stripe test mode setup
6. **CROSS** — smoke tests, run last

### Shared helpers needed
- `login(page, email?, password?)` — already exists in `dashboard-greeting.spec.ts`, extract to `e2e/helpers.ts`
- `loginAsPro(page)` — variant using pro test account
- `completeQuizSession(page, n?)` — answer N questions to create session data for dashboard tests
