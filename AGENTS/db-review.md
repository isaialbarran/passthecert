# Database Review — PassTheCert

_Generado el 2026-04-03_

---

## Estado general: 🟢 Verde

El esquema es sólido para un MVP. RLS activado donde importa, índices en los puntos correctos, triggers bien pensados. Hay un par de cosas a vigilar antes del lanzamiento.

---

## Tablas

### `profiles`
Extiende `auth.users` 1:1. Almacena datos del perfil + suscripción.

| Campo | Tipo | Notas |
|---|---|---|
| `id` | uuid (FK → auth.users) | PK, cascade delete |
| `email`, `full_name`, `avatar_url` | text | Sincronizados desde Google OAuth vía trigger |
| `stripe_customer_id` | text (unique) | Referencia a Stripe |
| `subscription_status` | text | `trialing` \| `active` \| `canceled` \| `past_due` |
| `subscription_tier` | text | `free` \| `pro` |
| `trial_ends_at` | timestamptz | — |

**RLS:** ✅ Select y Update propios únicamente.
**Trigger:** `on_auth_user_created` auto-crea el perfil al registrarse. El perfil de `readiness_score` NO se crea en este trigger (ver aviso abajo).

---

### `exams`
Catálogo de certificaciones (Security+, AWS, etc.). Sin RLS — contenido público de solo lectura.

| Campo | Notas |
|---|---|
| `slug` | Identificador de URL (`comptia-security-plus`) |
| `pass_score` | Sobre 900 (Security+ = 750) |
| `total_questions`, `duration_mins` | Metadata del examen |

**Seed:** 1 examen → CompTIA Security+ SY0-701.

---

### `domains`
Temas del examen. FK a `exams`, cascade delete.

| Campo | Notas |
|---|---|
| `code` | `1.0` … `5.0` |
| `weight_pct` | % del examen (suman 100%) |

**Seed:** 5 dominios oficiales de Security+ SY0-701:
- 1.0 General Security Concepts — 12%
- 2.0 Threats, Vulnerabilities, and Mitigations — 22%
- 3.0 Security Architecture — 18%
- 4.0 Security Operations — 28%
- 5.0 Security Program Management and Oversight — 20%

---

### `questions`
Banco de preguntas. Sin RLS — el `correct_key` es visible vía anon key (ver aviso).

| Campo | Notas |
|---|---|
| `stem` | Texto de la pregunta |
| `options` | `jsonb` array: `[{"key":"A","text":"..."}]` |
| `correct_key` | `"A"` \| `"B"` \| `"C"` \| `"D"` |
| `explanation` | Obligatorio, sin excepción |
| `difficulty` | `easy` \| `medium` \| `hard` |
| `question_type` | `single` \| `multi` |
| `tags` | `text[]` (ej: `['encryption','PKI']`) |

**Índices:** `exam_id`, `domain_id` ✅
**Seed:** 5 preguntas de muestra (1 por dominio). Necesita expandirse a 100+ antes del lanzamiento.

---

### `user_responses`
Cada intento de respuesta del usuario. También almacena el estado SM-2 por pregunta.

| Campo | Notas |
|---|---|
| `selected_key` + `is_correct` | Respuesta y resultado |
| `time_spent_secs` | Para analytics futuros |
| `repetitions`, `ease_factor`, `interval_days`, `next_review_at` | Algoritmo SM-2 |
| `session_id` | Agrupa respuestas de la misma sesión |

**RLS:** ✅ Select e Insert propios únicamente.
**Índices:** `(user_id, question_id)` y `(user_id, next_review_at)` — correctos para las queries SM-2.

---

### `quiz_sessions`
Registra cada sesión de quiz.

| Campo | Notas |
|---|---|
| `mode` | `random_10` \| `full_exam` \| `review_mistakes` \| `domain_focus` |
| `domain_id` | null = todos los dominios |
| `score_pct` | 0–100, se rellena al completar |
| `is_completed` + `completed_at` | Estado de la sesión |

**RLS:** ✅ All (select/insert/update/delete) propios.

---

### `readiness_scores`
Score denormalizado para el dashboard. 1 fila por usuario (unique en `user_id`).

| Campo | Notas |
|---|---|
| `overall_score` | 0–100, probabilidad de pasar |
| `domain_scores` | `jsonb` → `{"domain_id": score_pct}` |
| `questions_seen` / `questions_mastered` | Mastered = correcto 3+ veces |
| `current_streak` | Días consecutivos de estudio |

**RLS:** ✅ Select y Update propios.
**Trigger:** `updated_at` auto-actualizado.

---

## Triggers

| Trigger | Tabla | Cuándo | Qué hace |
|---|---|---|---|
| `on_auth_user_created` | `auth.users` | AFTER INSERT | Crea `profiles` con datos de Google OAuth |
| `profiles_updated_at` | `profiles` | BEFORE UPDATE | Actualiza `updated_at` |
| `readiness_scores_updated_at` | `readiness_scores` | BEFORE UPDATE | Actualiza `updated_at` |

---

## Avisos (no bloqueantes para MVP)

### ⚠️ 1. `correct_key` expuesto vía anon key
`questions` no tiene RLS. Cualquiera con la `publishable_key` puede consultar todas las respuestas correctas vía REST. Para un MVP de exam prep esto es común y aceptable (las respuestas están en cualquier libro), pero es un dato a tener en cuenta si quieres evitar que bots extraigan el banco completo. Solución futura: si quieres filtrar visibilidad, usa RLS para exponer sólo filas válidas (por ejemplo `is_active = true`), pero no como mecanismo de “limitación de filas”. Para reducir scraping de forma efectiva, sirve las preguntas mediante una RPC/Edge Function que devuelva un subconjunto aleatorio y/o expón una vista pública que omita `correct_key`.

### ⚠️ 2. `readiness_scores` no se crea en el trigger de signup
El trigger `on_auth_user_created` sólo inserta en `profiles`. La fila de `readiness_scores` deberá crearse aparte (probablemente en la primera sesión o en un upsert desde la app). Considera añadirla al trigger para garantizar consistencia.

### ⚠️ 3. Banco de preguntas insuficiente para lanzamiento
El seed tiene 5 preguntas. El modo `random_10` necesita al menos 10 por dominio, y `full_exam` necesita 90. Esto es una tarea de contenido, no de código — pero bloquea el lanzamiento.

### ℹ️ 4. `subscription_status` y `subscription_tier` son text sin constraint
Considera añadir un `check` constraint para garantizar valores válidos. Bajo carga, un bug en el webhook de Stripe podría escribir un estado inválido.

---

## Resumen ejecutivo

El esquema está bien diseñado para el alcance del MVP. La separación entre contenido público (`exams`, `domains`, `questions`) y datos de usuario (`profiles`, `user_responses`, `quiz_sessions`, `readiness_scores`) es correcta. RLS está activado donde debe estarlo. El modelo SM-2 está correctamente embebido en `user_responses`. Los índices cubren los access patterns críticos.

**Antes del lanzamiento:**
1. Ampliar banco de preguntas a 100+
2. Añadir `readiness_scores` insert al trigger `on_auth_user_created`
3. Decidir si añadir RLS a `questions` (opcional para MVP)
