# LAUNCH_PLAN.md — Sprint de lanzamiento (1 semana)

> **Goal:** Pasar de "desplegado sin confianza" a **5 pagos reales en las 72h post-launch**.
>
> **Source of truth:** Este archivo. Marca cada checkbox al cerrar la tarea. Anota fricciones reales en la sección "Notas del día" — sirven para el retro post-launch.
>
> **No agregar features fuera de `INSTRUCTIONS.md` durante este sprint.**

---

## Métricas norte (instrumentar en C2, revisar diario desde el viernes)

| Métrica | Target | Lectura actual |
|---|---|---|
| % completion del diagnóstico (10/10) | ≥ 60% | _pendiente_ |
| % email-to-checkout (lead → click upgrade) | ≥ 5% | _pendiente_ |
| % first quiz session post-pago (en 24h) | ≥ 80% | _pendiente_ |
| Pagos reales en 72h post-launch | ≥ 5 | _pendiente_ |

---

## Lunes — Auditar contenido + setup de QA

- [x] **A1** Auditar el banco de preguntas _(3h)_
  - ✅ Hecho — ver `QUESTION_AUDIT.md`. **Hallazgo clave:** banco real es **305 preguntas**, no 105 (`QUESTION_INVENTORY.md` está desactualizado). Cero `correct_key` factualmente incorrecto detectado → **sin bloqueantes P0 de contenido**.
  - Diferencia entre batches: batch 2 (migrations 008–012, ~182 preguntas) refuta cada distractor en contexto. Batch 1 (seed + 003–007, ~123 preguntas) define distractores en abstracto pero no los aterriza al escenario.
- [ ] **A2** Reescribir explicaciones débiles _(4h)_ → **deferred a post-launch**
  - El audit recomienda **NO reescribir batch 1 esta semana** (~80 preguntas, 6h). Lanza primero, instrumenta `question_id` + `is_correct` en PostHog (C2), y reescribe **solo las top 20 con peor performance** después de los primeros 20-30 usuarios reales.
  - Razón: sin datos esto es intuición; el funnel/checkout/email mueven más la aguja en semana 1.
  - Movido a "Stretch / post-launch".
- [ ] **A5** Line-edits puntuales del audit §5 _(30m)_ ← **micro-tarea blocker-free**
  - 5 fixes de terminología/wording que NO son reescrituras: `seed.sql:202` (Credential replay → Replay attack), `seed.sql:230-238` + `007:158-166` (white/black/gray-box → known/unknown environment), `006:236-244` (OAuth: "authentication protocol" → "open-standard protocol").
  - Pueden ir en un commit aparte mientras avanza el resto del sprint.
- [ ] **A6** Actualizar `QUESTION_INVENTORY.md` _(10m)_
  - Reflejar 305 (no 105), 5 archivos batch 2 nuevos, distribución real por dominio. Datos exactos en `QUESTION_AUDIT.md` §1.
- [x] **B1** Crear cuentas de test (free + pro) _(30m)_
  - ✅ `.env.local` con `TEST_USER_EMAIL/PASSWORD` + `TEST_PRO_EMAIL/PASSWORD` + `STRIPE_SECRET_KEY` (sk_test). Pro account flagged en Supabase.
  - ⏳ Pendiente: replicar las 5 vars en **Vercel** (production env) y como **GitHub Actions secrets** (necesario para B10).
- [x] **B2** Extraer `login()` a `e2e/helpers.ts` _(30m)_
  - ✅ Hecho. `helpers.ts` exporta `login`, `loginAsPro`, `hasFreeCredentials`, `hasProCredentials`. `smoke.spec.ts` y `dashboard-greeting.spec.ts` ya lo importan.
  - ✅ Bonus: `playwright.config.ts` ahora carga `.env.local` con `process.loadEnvFile`. Sin esto, los specs auth-gated se skipeaban silenciosamente (los `process.env` se leen al cargar el módulo, antes de que el webServer los exponga).

**Notas del día:**
> 2026-04-27 — Corrida full local: **29/29 green** (smoke 7, dashboard-greeting 6, diagnostic 6, quiz 6, billing 4). Tiempo total ~2 min. Bug encontrado: env loading (ver B2). PR [#80](https://github.com/isaialbarran/passthecert/pull/80).

---

## Martes — Tests del revenue path + expansión de banco

- [x] **A3** Expandir banco a 200 preguntas _(5h)_
  - ✅ **Ya en 305** (target original 200, stretch 300 también superado). Migrations 008–012 (batch 2) ya añadieron 182 preguntas con explicaciones al "gold standard" del audit. **No se necesita expansión más.**
- [x] **A4** Spot-check en frío de 30 preguntas _(1h)_
  - ✅ Cubierto por `QUESTION_AUDIT.md` §3: revisión manual sobre seed + 10 migrations, cero `correct_key` incorrecto. Sin ambigüedades de respuesta correcta.
- [ ] **B3** AUTH-03 + AUTH-05 _(1h)_
  - Login con valid creds → `/dashboard`
  - Signout limpia sesión y redirige a `/`
- [x] **B4** QUIZ-01..04 _(2h)_
  - ✅ Hecho y verificado verde en `e2e/quiz.spec.ts`. QUIZ-01 (render + 4 opciones), QUIZ-02 (feedback), QUIZ-03 (explicación >20 chars), QUIZ-04 (Q2 ≠ Q1). **Requiere `TEST_PRO_EMAIL/PASSWORD`** (free users → Paywall).
- [x] **B5** QUIZ-06: completar sesión muestra score _(1h)_
  - ✅ Hecho y verificado verde. Test corre las 10 preguntas y verifica "Quiz Complete!" + link a dashboard. ~50s/run por los Server Actions secuenciales.

**Notas del día:**
> 2026-04-27 — B4 + B5 corren verde con `TEST_PRO_*` seteado. PR [#80](https://github.com/isaialbarran/passthecert/pull/80).

---

## Miércoles — Cierre de QA + Stripe end-to-end

- [ ] **B6** DIAG-07..09: completar diagnóstico + lead capture _(2h)_ ← **siguiente tarea**
  - Las 4 P0 pendientes del diagnostic (`e2e/TEST_MATRIX.md` §1): DIAG-07 (completar 10/10 → results), DIAG-08 (email gate aparece en "See Full Results"), DIAG-09 (`submitDiagnosticLead` server action OK).
  - Patrón a reusar: `e2e/diagnostic.spec.ts` ya cubre TC-01..TC-06; añadir TC-07..TC-10 al mismo archivo.
- [x] **B7** BILL-02: clic upgrade → Stripe Checkout _(1h)_
  - ✅ Hecho y verificado verde en `e2e/billing.spec.ts`. Verifica `https://checkout.stripe.com/(c/)?pay/`. Skipea si la STRIPE_SECRET_KEY es dummy o si el TEST_USER ya está suscrito (resetear a `inactive` en Supabase para correr).
- [x] **B8** **BILL-03** webhook → pro _(2h)_
  - ✅ Hecho y verificado verde en `e2e/billing-webhook.spec.ts`. **Pivote vs el plan original:** el evento que flipa `subscription_status` + `tier='pro'` es `customer.subscription.created/.updated`, NO `checkout.session.completed` (este último solo persiste `stripe_customer_id`). Ver `app/api/webhooks/stripe/route.ts:73-141`.
  - **Enfoque:** payload firmado en código con `stripe.webhooks.generateTestHeaderString()` y POST directo a `/api/webhooks/stripe` — no necesita `stripe listen`. Totalmente automatizable en CI.
  - 4 tests verde: BILL-03 (active → pro), BILL-04 (trialing → pro + trial_ends_at), BILL-06 (deleted → canceled/free), BILL-07 (payment_failed → past_due). ~7s.
  - El riesgo no cubierto (`stripe listen` real + signing en producción) lo absorbe **D5** (test con tarjeta verdadera).
- [ ] **B9** CROSS-02 + CROSS-04: smoke + console _(1h)_
- [ ] **B10** GitHub Actions: e2e en cada push a `main` _(1h)_
  - Workflow simple: install → build → `npm run test:e2e`
  - Secrets: `TEST_USER_*`, `TEST_PRO_*`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRO_PRICE_ID`, `NEXT_PUBLIC_SUPABASE_URL`, `SUPABASE_SERVICE_ROLE_KEY`, `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY`, `RESEND_API_KEY`, `NEXT_PUBLIC_APP_URL`.
  - Bloquea merges si rojo.

**Notas del día:**
> 2026-04-27 — B8 verde con 4 tests de webhook (BILL-03/04/06/07). Coverage del workflow Billing pasó de 13% a 63%. PR [#80](https://github.com/isaialbarran/passthecert/pull/80).

---

## Jueves — Validación con usuarios + Stripe live

- [ ] **C1** Reclutar 5–10 beta testers _(1h)_
  - DM personalizados a contactos en IT/security
  - Post en Discord/Slack de comunidades
  - Oferta: 1 mes gratis a cambio de 15 min de feedback en día 3
  - Trackear cada uno en `BETA_FEEDBACK.md`
- [ ] **C2** Instrumentar PostHog en el funnel _(2h)_
  - Eventos: `diagnostic_started`, `diagnostic_completed`, `lead_submitted`, `paywall_viewed`, `checkout_started`, `subscription_created`, `quiz_session_completed`
  - **Crítico:** en cada evento `submitAnswer`/`question_answered` incluir `{ question_id, is_correct, domain }`. Esto alimenta el A2 deferred — sin esto no hay forma de priorizar qué reescribir post-launch.
- [ ] **C3** Definir 3 métricas norte en PostHog dashboard _(30m)_
  - Targets en la tabla de arriba
- [ ] **D1** Verificar entregabilidad del email _(1h)_
  - DKIM/SPF/DMARC configurados en `passthecert.com`
  - Mandar diagnostic report a 3 inboxes (Gmail/Outlook/iCloud) → confirmar **NO va a spam**
- [ ] **D2** Stripe en modo live + price ID _(1h)_
  - Crear producto Pro €14.99/mo en live
  - `STRIPE_PRO_PRICE_ID` y `STRIPE_WEBHOOK_SECRET` en Vercel (production env)
  - Webhook endpoint: `https://passthecert.com/api/webhooks/stripe`
- [ ] **D3** Pulir landing + pricing _(3h)_
  - Hero: una promesa concreta — "Pasa Security+ a la primera, sin memorizar 1500 flashcards"
  - CTA único: "Take the free diagnostic"
  - Garantía de 7 días visible **sin scroll** en `/pricing`

**Notas del día:**
>

---

## Viernes — Pulido comercial + primer pago real

- [ ] **D4** FAQ + términos + refund policy _(2h)_
  - 5 preguntas: ¿cancelar? ¿garantía? ¿última versión SY0-701? ¿móvil? ¿tiempo para pasar?
  - Privacy + ToS básicos en footer
- [ ] **D5** **Comprar tarjeta real → primer test live** _(30m)_
  - Tú haces el flow completo con tarjeta verdadera €14.99
  - Signup → diagnostic → checkout → ver dashboard como pro → pedir refund vía Stripe portal
  - Detecta el 90% de los problemas reales antes de invitar usuarios
- [ ] **D6** Email de bienvenida post-pago _(1h)_
  - Resend template: "Bienvenido — aquí está tu primera sesión"
  - Link directo a `/quiz/comptia-security-plus`
- [ ] **C4 (1/2)** Llamadas de feedback — primeras 2 sesiones _(1h)_
  - Capturar en `BETA_FEEDBACK.md`

**Notas del día:**
>

---

## Sábado — Iteración rápida sobre feedback

- [ ] **C4 (2/2)** Llamadas de feedback — sesiones 3-5 _(1h)_
- [ ] **C5** Iterar 1–3 fixes según feedback _(3h)_
  - Lo más probable: copy del results page, claridad del readiness score, velocidad percibida
  - **NO empezar features nuevas**

**Notas del día:**
>

---

## Domingo — Soft launch público

- [ ] **E1** Posts en /r/CompTIA y /r/comptia_security _(1h)_
  - Tono honesto, NO hard-sell
  - Link al **diagnóstico gratis**, no a pricing
  - Leer reglas de cada subreddit primero
- [ ] **E2** Discord IT/security communities _(1h)_
  - TryHackMe, HackTheBox, Cybrary, ProfessorMesser
  - Foco en "feedback wanted"
- [ ] **E3** LinkedIn personal: la historia _(30m)_
  - Storytelling > feature list
  - Link al diagnóstico
- [ ] **E4** DM a 20 contactos en IT estudiando cert _(2h)_
  - 1:1 personalizado >> post genérico
  - Mínimo 20 mensajes
- [ ] **E5** Watch party: Stripe + PostHog + logs _(ongoing)_
  - Domingo noche y lunes monitoreas: nuevos signups, errores, conversión a paid
  - **Goal: 5 pagos en 72h post-launch**

**Notas del día:**
>

---

## Stretch / post-launch (solo si todo lo de arriba está verde)

- [x] Llegar a 300 preguntas (target original del INSTRUCTIONS.md) — ✅ 305 al 2026-04-27.
- [ ] **A2 (deferred):** reescribir top-20 preguntas de batch 1 al estándar de batch 2, **priorizadas por % incorrecto en PostHog** (no por intuición). Plantilla en `QUESTION_AUDIT.md` §8.
- [ ] QUIZ-09..11: paywall enforcement (solo si introduces free tier)
- [ ] Affiliate manual con 3 creators IT en YouTube (30% recurring)

---

## Definition of Done del sprint

- [ ] **Confianza técnica:** todos los e2e P0 en verde (auth, quiz, billing, diagnostic). CI bloquea merges si rojo.
- [x] **Confianza de contenido:** ✅ 305 preguntas (target 200, superado). Cero `correct_key` incorrecto (`QUESTION_AUDIT.md` §3). Pendiente: 4 line-edits de terminología (A5) — no bloqueante.
- [ ] **Confianza de valor:** 5 beta users entrevistados, 3 fixes prioritarios shippeados, métricas norte instrumentadas (+ `question_id` en `quiz_session_completed` para alimentar A2 post-launch).
- [ ] **Confianza comercial:** 1 cobro real con tarjeta verdadera + refund probado. Email no cae en spam. Webhook actualiza profile en producción.
- [ ] **Resultado:** ≥ 5 pagos reales en las 72h post-launch.

---

## Retro post-launch (rellenar el lunes siguiente)

**Qué funcionó:**
>

**Qué no funcionó:**
>

**Qué cambiaríamos para la próxima cert (Network+, AWS, etc.):**
>

**Métricas finales:**
- Diagnostic completion rate: __%
- Email-to-checkout conversion: __%
- First-session-after-pay rate: __%
- Pagos en 72h: __
- Refunds en 7 días: __
