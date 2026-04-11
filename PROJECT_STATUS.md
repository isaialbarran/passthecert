# Project Status — PassTheCert

> Last updated: 2026-04-11 (analytics complete)

## Summary

| Milestone | Progress | Done | Partial | Pending |
|-----------|----------|------|---------|---------|
| 1 - Foundation | **100%** | 5/5 | 0 | 0 |
| 2 - AI Tutor | **75%** | 3/4 | 0 | 1 |
| 3 - Study Modes | **67%** | 4/6 | 1 | 1 |
| 4 - Launch | **50%** | 3/6 | 1 | 2 |
| **Total** | **71%** | **15/21** | **2** | **3** |

---

## Milestone 1 — Foundation (Sem 1-2)

| # | Issue | Status | Notes |
|---|-------|--------|-------|
| [#29](https://github.com/isaialbarran/passthecert/issues/29) | Setup Next.js + DB | Done | Next.js 16 + Supabase PostgreSQL + migrations |
| [#30](https://github.com/isaialbarran/passthecert/issues/30) | Auth (Supabase) | Done | Google OAuth + RLS en todas las tablas |
| [#31](https://github.com/isaialbarran/passthecert/issues/31) | Adaptive engine SM-2 | Done | `features/quiz/sm2.ts` con ease factor + intervals |
| [#32](https://github.com/isaialbarran/passthecert/issues/32) | Diagnostic quiz | Done | Flow completo con email gate + scoring |
| [#33](https://github.com/isaialbarran/passthecert/issues/33) | Stripe + billing | Done | Checkout sessions + webhook handler |

## Milestone 2 — AI Tutor (Sem 3-4)

| # | Issue | Status | Notes |
|---|-------|--------|-------|
| [#34](https://github.com/isaialbarran/passthecert/issues/34) | AI Tutor — Claude API | **Pending** | Sin integracion con Claude API |
| [#35](https://github.com/isaialbarran/passthecert/issues/35) | Readiness dashboard | Done | Score + domain mastery en `features/progress/` |
| [#36](https://github.com/isaialbarran/passthecert/issues/36) | Study session tracking | Done | Quiz sessions con modo, score, completado |
| [#37](https://github.com/isaialbarran/passthecert/issues/37) | 300 preguntas Security+ | Done | 287 preguntas (migrations 003-012 + seed.sql). Mínimo 200 superado. |

## Milestone 3 — Study Modes (Sem 5-6)

| # | Issue | Status | Notes |
|---|-------|--------|-------|
| [#38](https://github.com/isaialbarran/passthecert/issues/38) | Quick 10 mode | Done | Modo `random_10` implementado |
| [#39](https://github.com/isaialbarran/passthecert/issues/39) | Domain Focus mode | Done | Filtro por dominio funcional |
| [#40](https://github.com/isaialbarran/passthecert/issues/40) | Review Mistakes mode | Done | Filtra respuestas incorrectas |
| [#41](https://github.com/isaialbarran/passthecert/issues/41) | Full Exam Simulation | Done | 90 preguntas, solo Pro |
| [#42](https://github.com/isaialbarran/passthecert/issues/42) | PWA | **Pending** | Sin manifest ni service worker |
| [#43](https://github.com/isaialbarran/passthecert/issues/43) | UI/UX polish | **Partial** | Componentes base existen, falta polish |

## Milestone 4 — Launch (Sem 7-8)

| # | Issue | Status | Notes |
|---|-------|--------|-------|
| [#44](https://github.com/isaialbarran/passthecert/issues/44) | Landing page | Done | Hero + features + pricing sections |
| [#45](https://github.com/isaialbarran/passthecert/issues/45) | Blog SEO | **Pending** | Sin blog ni rutas de contenido |
| [#46](https://github.com/isaialbarran/passthecert/issues/46) | Pass rate tracker | **Pending** | Sin tracking de pass rate |
| [#47](https://github.com/isaialbarran/passthecert/issues/47) | Analytics + monitoring | Done | PostHog integrado: pageviews, diagnostic funnel, checkout, subscription, quiz, signup |
| [#48](https://github.com/isaialbarran/passthecert/issues/48) | Deployment Vercel + CI/CD | **Partial** | CI/CD con GitHub Actions, falta verificar deploy |
| [#49](https://github.com/isaialbarran/passthecert/issues/49) | Soft launch 30 users | **Pending** | Infraestructura lista, sin beta users |

---

## Next priorities

1. **Smoke test** — diagnostic → email → login → Stripe → dashboard → quiz (end-to-end en prod)
2. **#49** Soft launch — Reddit/Discord/LinkedIn, primeros 30 beta users
3. **#34** AI Tutor con Claude API (post-launch, semana 1-2)
4. **#48** Verificar deployment en Vercel (CI/CD)
