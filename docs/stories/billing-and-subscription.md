# Historia de Usuario: Facturación y Suscripción

## Épica

**Como** visitante o usuario registrado,
**quiero** poder suscribirme al plan Pro (€29/mes) ya sea después del diagnóstico o directamente desde pricing, y gestionar mi información de facturación cuando lo necesite,
**para que** pueda acceder al contenido de preparación sin fricciones y mantener mis datos de pago actualizados.

---

## HU-1: Pago post-diagnóstico (camino principal)

**Como** visitante que acaba de completar el test diagnóstico,
**quiero** pagar desde la página de resultados,
**para que** pueda desbloquear mi plan de estudio personalizado inmediatamente.

### Criterios de aceptación

1. **Given** el visitante está en la página de resultados del diagnóstico,
   **when** hace click en "Empieza tu plan de estudio personalizado",
   **then** se le redirige a Google OAuth si no tiene cuenta, y después a Stripe Checkout con el plan Pro (€29/mes).

2. **Given** el visitante ya tiene una sesión activa (hizo login antes),
   **when** hace click en el CTA,
   **then** va directamente a Stripe Checkout sin pasar por login.

3. **Given** cualquier CTA de pago en la página de resultados,
   **then** el texto "Garantía de devolución de 7 días, sin preguntas" es visible junto al botón.

4. **Given** el pago se completa exitosamente en Stripe,
   **when** el webhook confirma la suscripción,
   **then** `profiles.subscription_status` se actualiza a `active` y el usuario es redirigido al dashboard.

5. **Given** el usuario paga y su email coincide con un registro en `diagnostic_leads`,
   **when** se crea la cuenta,
   **then** se actualiza `diagnostic_leads.converted_at = now()`.

---

## HU-2: Pago directo sin diagnóstico

**Como** visitante que ya sabe que quiere prepararse para Security+,
**quiero** pagar directamente desde la página de pricing sin hacer el test diagnóstico,
**para que** no tenga que completar pasos innecesarios antes de empezar a estudiar.

### Criterios de aceptación

1. **Given** el visitante está en la página de pricing (`/pricing`),
   **when** hace click en "Suscríbete — €29/mes",
   **then** se le redirige a Google OAuth y después a Stripe Checkout.

2. **Given** el visitante llega a la landing page,
   **when** busca un camino directo al pago,
   **then** existe un enlace visible a `/pricing` en la navegación o como CTA secundario.

3. **Given** un usuario que paga sin haber hecho el diagnóstico,
   **when** completa el pago exitosamente,
   **then** es redirigido al dashboard sin errores — el diagnóstico NO es un prerequisito técnico.

4. **Given** un usuario sin registro en `diagnostic_leads`,
   **when** se suscribe directamente,
   **then** no se crea ningún registro en `diagnostic_leads` — solo se actualiza `profiles`.

---

## HU-3: Paywall en rutas protegidas

**Como** usuario autenticado sin suscripción activa,
**quiero** ver un mensaje claro que me indique que necesito suscribirme,
**para que** entienda por qué no puedo acceder al contenido y sepa cómo hacerlo.

### Criterios de aceptación

1. **Given** un usuario autenticado con `subscription_status != 'active'`,
   **when** intenta acceder a `/quiz`, `/dashboard`, o cualquier ruta protegida,
   **then** se le redirige a una página de checkout/paywall.

2. **Given** la página de paywall,
   **then** muestra el precio (€29/mes), la garantía de 7 días, y un único botón hacia Stripe Checkout.

3. **Given** el usuario completa el pago desde el paywall,
   **when** el webhook confirma,
   **then** es redirigido automáticamente a la ruta que intentaba acceder originalmente.

---

## HU-4: Gestión de información de facturación

**Como** usuario suscrito,
**quiero** poder actualizar mi método de pago y ver mi información de facturación,
**para que** pueda mantener mis datos al día y evitar interrupciones en mi suscripción.

### Criterios de aceptación

1. **Given** un usuario con `subscription_status = 'active'`,
   **when** navega a la sección de configuración/cuenta,
   **then** ve un apartado "Facturación" con:
   - Estado de la suscripción (activa/cancelada)
   - Fecha de la próxima facturación
   - Últimos 4 dígitos del método de pago actual

2. **Given** el usuario quiere actualizar su método de pago,
   **when** hace click en "Actualizar método de pago",
   **then** se abre el portal de facturación de Stripe (Stripe Customer Portal) en una nueva pestaña.

3. **Given** el usuario quiere ver su historial de facturas,
   **when** hace click en "Ver facturas",
   **then** se abre el portal de Stripe donde puede descargar sus recibos.

4. **Given** el usuario actualiza su tarjeta en el portal de Stripe,
   **when** regresa a la app,
   **then** los últimos 4 dígitos reflejan el nuevo método de pago (puede requerir refresh).

5. **Given** el usuario quiere cancelar su suscripción,
   **when** hace click en "Cancelar suscripción",
   **then** se le redirige al portal de Stripe para confirmar la cancelación — la app NO gestiona cancelaciones directamente.

---

## HU-5: Webhook de Stripe y sincronización de estado

**Como** sistema,
**quiero** procesar los eventos de Stripe correctamente,
**para que** el estado de suscripción del usuario esté siempre sincronizado.

### Criterios de aceptación

1. **Given** Stripe envía `checkout.session.completed`,
   **then** se actualiza `profiles.subscription_status = 'active'` y se guarda `stripe_customer_id`.

2. **Given** Stripe envía `customer.subscription.updated`,
   **when** el estado cambia a `canceled`, `past_due`, o `unpaid`,
   **then** `profiles.subscription_status` refleja el nuevo estado.

3. **Given** Stripe envía `customer.subscription.deleted`,
   **then** `profiles.subscription_status = 'canceled'` y `isPro()` retorna `false`.

4. **Given** Stripe envía `invoice.payment_failed`,
   **then** `profiles.subscription_status = 'past_due'` — el usuario mantiene acceso temporalmente pero ve un banner de aviso.

5. **Given** cualquier evento de webhook,
   **then** se verifica la firma del webhook antes de procesar (`stripe.webhooks.constructEvent`).

---

## Flujo visual (resumen)

```
Landing Page
├── CTA principal: "Test gratuito" ──→ /diagnostic ──→ Resultados ──→ Login ──→ Stripe Checkout ──→ /dashboard
├── CTA secundario / Nav: "Pricing" ──→ /pricing ──→ Login ──→ Stripe Checkout ──→ /dashboard
│
Ruta protegida (sin pago)
└── /quiz, /dashboard ──→ Paywall ──→ Stripe Checkout ──→ ruta original
│
Usuario suscrito
└── /settings ──→ Facturación ──→ Stripe Customer Portal (actualizar pago, ver facturas, cancelar)
```

---

## Fuera de alcance (MVP)

- Planes anuales o descuentos por periodo
- Múltiples tiers (solo Pro)
- Cupones o códigos promocionales
- Gestión de cancelación in-app (se delega a Stripe Portal)
- Facturación para empresas/equipos
- Cambio de plan (solo existe uno)
- Notificaciones por email de pago fallido (Stripe lo maneja nativamente)

---

## Métricas de éxito

| Métrica | Descripción | Target MVP |
|---------|-------------|------------|
| Conversión diagnóstico → pago | % de leads en `diagnostic_leads` con `converted_at` + `subscription_status = active` | >5% |
| Conversión directa | % de usuarios activos sin registro en `diagnostic_leads` | Tracking only |
| Churn mensual | % de suscriptores que cancelan en un mes | <10% |
| Pago fallido → recuperación | % de `past_due` que vuelven a `active` | >50% |
