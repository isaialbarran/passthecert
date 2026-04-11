# PassTheCert — Roadmap & Progress Tracker

> Última actualización: 2026-04-08 (revisión #1)
> North star metric: % de usuarios que pasan su certificación después de usar PassTheCert

---

## Resumen estratégico

**Posicionamiento:** "La forma más rápida de saber si estás listo para pasar. No es un juego. Es un sistema."

**Ventaja competitiva:** Spaced repetition real (SM-2) + Readiness Score visible + Diagnostic funnel sin fricción. Ningún competidor combina los tres.

**Competidores principales:**
| Competidor | Precio | Fortaleza | Nuestra ventaja |
|---|---|---|---|
| SecuSpark | $8.33/mo | Gamificación RPG | Nosotros: ciencia > juegos |
| Pocket Prep | $21/mo | UI pulida, daily questions | Nosotros: SM-2 real + más barato |
| Mindirus | Freemium | 16 certs, 51K preguntas | Nosotros: enfocados, mejor UX |
| ExamCompass | Gratis | Muchas preguntas | Nosotros: tracking + adaptive |

---

## Fase 1 — MVP (actual)

### Infraestructura & Auth
- [x] Migrations (001-007) — schema, diagnostic_leads, questions, indexes, RLS
- [x] Seed data (5 preguntas Security+ SY0-701)
- [x] proxy.ts — session refresh + protección de rutas (Next.js 16 usa proxy.ts, no middleware.ts)
- [x] Supabase clients (browser + server)
- [x] Stripe client
- [x] Resend client
- [x] Auth feature (actions, queries, schemas)
- [x] .env.example — template con todas las variables necesarias

### Diagnostic Funnel (Lead Magnet) — PRIORIDAD #1
- [x] Feature module (`features/diagnostic/`)
- [x] Ruta pública (`app/(marketing)/diagnostic/`) — no requiere login ✓
- [x] ~~Verificar:~~ localStorage almacena respuestas (STORAGE_KEY, TIMER_START_KEY) ✓
- [x] ~~Verificar:~~ email gate captura lead (upsert a diagnostic_leads) ✓
- [x] ~~Verificar:~~ email de reporte diagnóstico se envía via Resend ✓
- [ ] **Verificar:** resultados parciales (score visible, domains blurred) — necesita test manual
- [ ] **Verificar:** CTA en resultados redirige a signup/pago — necesita test manual

### Quiz Engine — PRIORIDAD #2
- [x] SM-2 algorithm (`features/quiz/sm2.ts`)
- [x] Feature module (`features/quiz/`)
- [x] Ruta quiz (`app/(app)/quiz/[certId]/`)
- [x] ~~Verificar:~~ submitAnswer guarda campos SM-2 (repetitions, ease_factor, interval_days, next_review_at) ✓
- [x] ~~Verificar:~~ readiness score se recalcula tras cada respuesta (updateReadinessScore) ✓
- [x] ~~queries.ts incompleto~~ — los 4 modos están en actions.ts:getNextQuestionForSession() ✓
- [ ] **Verificar:** modo `random_10` funciona — necesita test manual
- [ ] **Verificar:** modo `review_mistakes` funciona — necesita test manual
- [ ] **Verificar:** modo `domain_focus` funciona — necesita test manual
- [ ] **Verificar:** modo `full_exam` (90 preguntas, timer 90 min) — necesita test manual
- [ ] **Verificar:** explicación se muestra inmediatamente después de responder — necesita test manual

### Readiness Score & Dashboard — PRIORIDAD #3
- [x] Feature module (`features/progress/`)
- [x] Ruta dashboard (`app/(app)/dashboard/`)
- [x] ~~Verificar:~~ queries implementadas: getReadinessScore, getDomainMastery, getStudyStreak, getQuestionsMastered, getRecentSessions ✓
- [x] ~~Verificar:~~ CTA "Start Practice" existe (StartPracticeCta para Pro, UpgradeBanner para free) ✓
- [ ] **Verificar:** readiness score se muestra prominentemente — necesita test visual
- [ ] **Verificar:** domain mastery breakdown visible — necesita test visual
- [ ] **Verificar:** datos reales se renderizan correctamente — necesita test e2e

### Billing — PRIORIDAD #4
- [x] Feature module (`features/billing/`)
- [x] Stripe webhook endpoint (`app/api/webhooks/stripe/`)
- [x] Pricing page (`app/(marketing)/pricing/`)
- [x] ~~Verificar:~~ `isPro()` existe — checks subscription_tier === 'pro' && status === 'active' ✓
- [ ] **Verificar:** Stripe Checkout funciona (€29/mo) — necesita test con Stripe test mode
- [ ] **Verificar:** webhook actualiza `subscription_status` — necesita test e2e
- [ ] **Verificar:** "7-day money-back guarantee" visible en CTA — necesita test visual

### Landing Page
- [x] Ruta (`app/(marketing)/page.tsx`)
- [x] ~~Verificar:~~ CTA principal lleva a `/diagnostic` ✓
- [ ] **Verificar:** propuesta de valor clara y en inglés — necesita revisión visual
- [ ] **Verificar:** responsive (mobile + desktop) — necesita test visual

### Deploy
- [ ] Deploy a Vercel
- [ ] Conectar dominio passthecert.com
- [ ] Variables de entorno configuradas en Vercel
- [ ] Stripe webhook apuntando a URL de producción

---

## Fase 2 — Post-MVP (no construir hasta que Fase 1 esté completa)

- [ ] Expandir banco de preguntas a 100+ (mínimo 20 por dominio)
- [x] PostHog analytics (funnels, retention) — integrado en todas las features
- [ ] Email sequences post-diagnostic (nurture leads no convertidos)
- [ ] Mejoras UX basadas en feedback de primeros 5 usuarios pagados
- [ ] A/B test en pricing (€19 vs €29 vs €39)
- [ ] SEO: blog con contenido Security+ para tráfico orgánico

## Fase 3 — Crecimiento

- [ ] Segunda certificación (CompTIA Network+ o AWS Cloud Practitioner)
- [ ] App móvil (o PWA optimizada)
- [ ] Admin dashboard para gestionar preguntas
- [ ] AI-assisted question generation (con review humano)
- [ ] Referral program
- [ ] Team/enterprise plans

---

## Cómo usar este archivo

1. **Antes de cada sesión de trabajo:** revisa los `[ ]` pendientes y elige qué atacar
2. **Después de completar algo:** marca `[x]` y actualiza la fecha de última actualización
3. **Los items "Verificar"** significan que el código existe pero no se ha probado end-to-end
4. **Prioridades** indican el orden óptimo de trabajo — cada feature depende de la anterior
