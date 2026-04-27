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

- [ ] **A1** Auditar las 105 preguntas existentes _(3h)_
  - Hoja: ID, dominio, dificultad, ¿stem claro?, ¿correcto verificable?, ¿distractores plausibles?, ¿explicación enseña?
  - Output: lista de preguntas marcadas para reescritura
- [ ] **A2** Reescribir explicaciones débiles _(4h)_
  - Cada explicación debe decir **por qué el correcto SÍ y por qué cada distractor NO**
- [ ] **B1** Crear cuentas de test (free + pro) _(30m)_
  - Setear `TEST_USER_EMAIL/PASSWORD` y `TEST_PRO_EMAIL/PASSWORD` en Vercel + `.env.local`
  - Pro account: flag manual en Supabase → `subscription_status='active'`, `subscription_tier='pro'`
- [ ] **B2** Extraer `login()` a `e2e/helpers.ts` _(30m)_
  - Ya existe duplicado en `dashboard-greeting.spec.ts` — moverlo y reutilizar

**Notas del día:**
> _(escribe aquí: bloqueos, sorpresas, decisiones que tomaste)_

---

## Martes — Tests del revenue path + expansión de banco

- [ ] **A3** Expandir banco a 200 preguntas _(5h)_
  - Migrations 013–017, una por dominio
  - LLM-assisted, **revisión humana obligatoria** (regla del INSTRUCTIONS.md §11)
- [ ] **A4** Spot-check en frío de 30 preguntas _(1h)_
  - Tú u otro Security+ certificado responde sin ver respuesta
  - Cualquier pregunta donde el correcto sea ambiguo → reescritura inmediata
- [ ] **B3** AUTH-03 + AUTH-05 _(1h)_
  - Login con valid creds → `/dashboard`
  - Signout limpia sesión y redirige a `/`
- [ ] **B4** QUIZ-01..04 _(2h)_
  - Empezar `random_10` → render Q1 → click respuesta → ver feedback verde/rojo + explicación → click Next
- [ ] **B5** QUIZ-06: completar sesión muestra score _(1h)_

**Notas del día:**
>

---

## Miércoles — Cierre de QA + Stripe end-to-end

- [ ] **B6** DIAG-07..09: completar diagnóstico + lead capture _(2h)_
  - Las 4 P0 pendientes del diagnostic (`e2e/TEST_MATRIX.md` §1)
- [ ] **B7** BILL-02: clic upgrade → Stripe Checkout _(1h)_
  - Verifica que el redirect empieza con `https://checkout.stripe.com/`
- [ ] **B8** **BILL-03** con `stripe-cli`: webhook → pro _(2h)_
  - `stripe trigger checkout.session.completed`
  - Verificar `profile.subscription_status='active'` en Supabase
  - **Esta es la prueba más crítica del sprint**
- [ ] **B9** CROSS-02 + CROSS-04: smoke + console _(1h)_
- [ ] **B10** GitHub Actions: e2e en cada push a `main` _(1h)_
  - Workflow simple: install → build → `npm run test:e2e`
  - Secrets para `TEST_USER_*`
  - Bloquea merges si rojo

**Notas del día:**
>

---

## Jueves — Validación con usuarios + Stripe live

- [ ] **C1** Reclutar 5–10 beta testers _(1h)_
  - DM personalizados a contactos en IT/security
  - Post en Discord/Slack de comunidades
  - Oferta: 1 mes gratis a cambio de 15 min de feedback en día 3
  - Trackear cada uno en `BETA_FEEDBACK.md`
- [ ] **C2** Instrumentar PostHog en el funnel _(2h)_
  - Eventos: `diagnostic_started`, `diagnostic_completed`, `lead_submitted`, `paywall_viewed`, `checkout_started`, `subscription_created`, `quiz_session_completed`
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

- [ ] Llegar a 300 preguntas (target original del INSTRUCTIONS.md)
- [ ] QUIZ-09..11: paywall enforcement (solo si introduces free tier)
- [ ] Affiliate manual con 3 creators IT en YouTube (30% recurring)

---

## Definition of Done del sprint

- [ ] **Confianza técnica:** todos los e2e P0 en verde (auth, quiz, billing, diagnostic). CI bloquea merges si rojo.
- [ ] **Confianza de contenido:** 200 preguntas, todas con explicación que enseña, spot-check en frío sin ambigüedades.
- [ ] **Confianza de valor:** 5 beta users entrevistados, 3 fixes prioritarios shippeados, métricas norte instrumentadas.
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
