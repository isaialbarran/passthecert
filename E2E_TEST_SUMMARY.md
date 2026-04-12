# E2E Test Summary

> Last updated: 2026-04-12

## Current Setup

| Item | Detail |
|------|--------|
| Framework | Playwright `^1.59.1` |
| Config | `playwright.config.ts` |
| Test dir | `e2e/` |
| Workers | 1 (sequential) |
| Browser | Chromium (Desktop Chrome) |
| Base URL | `http://localhost:3000` |
| Retries | 0 local / 1 CI |
| Env vars | `TEST_USER_EMAIL`, `TEST_USER_PASSWORD` |

### npm scripts

```bash
npm run test:e2e          # Run all tests
npm run test:e2e:ui       # UI mode
npm run test:e2e:headed   # Headed browser
npm run test:e2e:report   # View HTML report
```

---

## Existing Tests (12 test cases)

### 1. `e2e/dashboard-greeting.spec.ts` — 6 tests

| ID | Test | What it validates |
|----|------|-------------------|
| TC-01 | Greeting with name and time | `dashboard-greeting` visible, matches "Good (morning\|afternoon\|evening)", no "undefined"/"null" |
| TC-04 | Inline stats (readiness, streak, mastered) | `stat-readiness`, `stat-streak`, `stat-mastered` visible; readiness ends with `%` |
| TC-05/06 | Review Mistakes button (conditional) | If visible, href contains `review_mistakes` |
| TC-09 | Stats show valid numeric values | readiness = `^\d+%$`, streak/mastered contain digits |
| TC-10 | Readiness label is valid | Contains "Not Ready", "Getting There", or "Ready to Pass" |
| TC-11 | Unauthenticated redirect | `/dashboard` without login redirects to `/auth/login` |

### 2. `e2e/diagnostic.spec.ts` — 6 tests

| ID | Test | What it validates |
|----|------|-------------------|
| TC-01 | Intro shows 10 questions, 5 domains, 10 min | Heading "Security+ Diagnostic" + numbers visible |
| TC-02 | Timer appears on quiz start | "Time Remaining" visible, starts at ~10:00 |
| TC-03 | No feedback between questions | Advancing shows new question, no "Correct"/"Incorrect"/"Explanation" |
| TC-04 | Progress bar fills incrementally | Width % at Q2 > Q1 |
| TC-05 | Refresh resumes at Q2 after answering Q1 | localStorage persistence survives reload |
| TC-06 | Retake clears state and returns to intro | "Retake Diagnostic" clears localStorage, shows "Start Diagnostic" |

---

## Coverage Gap Analysis

### Coverage by feature

| Feature | Route(s) | Tests | Coverage |
|---------|----------|-------|----------|
| **Auth** | `/auth/login`, `/auth/signup`, `/auth/forgot-password`, `/auth/reset-password`, `/auth/callback` | 1 (redirect only) | LOW |
| **Dashboard** | `/dashboard` | 6 | MEDIUM |
| **Diagnostic** | `/diagnostic` | 6 | MEDIUM |
| **Quiz (SM-2)** | `/quiz/[certId]` | 0 | NONE |
| **Settings** | `/settings` | 0 | NONE |
| **Pricing / Billing** | `/pricing`, Stripe webhook | 0 | NONE |
| **Landing** | `/` | 0 | NONE |

---

## Pending Tests — Priority Order

### P0 — Critical (core user journey)

#### `e2e/auth.spec.ts` (new)
- [ ] Login with valid credentials redirects to `/dashboard`
- [ ] Login with invalid credentials shows error message
- [ ] Signup creates account and redirects
- [ ] Forgot password sends reset email (or shows confirmation)
- [ ] Reset password with valid token updates password
- [ ] Logout clears session and redirects to `/auth/login`
- [ ] Google OAuth button is visible and has correct href
- [ ] Protected routes redirect to login when unauthenticated

#### `e2e/quiz.spec.ts` (new)
- [ ] Quiz page loads questions for valid certId
- [ ] Selecting an answer shows correct/incorrect feedback (SM-2 mode)
- [ ] SM-2 difficulty buttons appear after answering
- [ ] Answering advances to next question
- [ ] Quiz tracks progress (answered count updates)
- [ ] Empty question bank shows appropriate message
- [ ] Quiz respects subscription status (free tier limits)

### P1 — Important (revenue + retention)

#### `e2e/pricing.spec.ts` (new)
- [ ] Pricing page renders plans with correct price (€14.99/mo)
- [ ] CTA button links to Stripe checkout or signup
- [ ] Free tier features listed correctly
- [ ] Pro tier features listed correctly

#### `e2e/settings.spec.ts` (new)
- [ ] Settings page loads for authenticated user
- [ ] User can update profile info
- [ ] Subscription status is displayed correctly
- [ ] Cancel subscription flow works (if implemented)

### P2 — Hardening existing tests

#### `e2e/dashboard-greeting.spec.ts` (improve)
- [ ] Greeting changes based on time of day (mock clock)
- [ ] Dashboard loads correctly with zero quiz history (new user)
- [ ] Dashboard handles API errors gracefully (shows fallback UI)
- [ ] Navigation links (start quiz, settings) work correctly
- [ ] Mobile viewport renders correctly

#### `e2e/diagnostic.spec.ts` (improve)
- [ ] Complete all 10 questions and verify results page
- [ ] Results page shows domain breakdown
- [ ] Results page shows CTA to sign up / start studying
- [ ] Timer expiry behavior (what happens at 0:00?)
- [ ] Back button / navigation during quiz doesn't break state
- [ ] Mobile viewport renders quiz correctly

### P3 — Nice to have

#### `e2e/landing.spec.ts` (new)
- [ ] Landing page renders hero, features, CTA
- [ ] CTA links to `/auth/signup` or `/pricing`
- [ ] Page is responsive (mobile/tablet/desktop)

#### `e2e/navigation.spec.ts` (new)
- [ ] Sidebar/nav links work for authenticated users
- [ ] Active route is highlighted
- [ ] Mobile menu opens/closes correctly

---

## Recommendations

1. **Extract shared helpers** — `login()` is duplicated. Create `e2e/helpers/auth.ts` with shared login/logout utilities.
2. **Add fixtures** — Use Playwright fixtures for authenticated state to avoid logging in before every test suite.
3. **Clock mocking** — Use `page.clock` to test time-dependent logic (greeting, timer).
4. **CI integration** — Add Playwright to GitHub Actions workflow.
5. **Visual regression** — Consider snapshot testing for key pages once UI stabilizes.
6. **API mocking** — Use `page.route()` to test error states without needing server-side failures.
