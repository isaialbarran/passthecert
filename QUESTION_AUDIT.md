# QUESTION_AUDIT.md — Auditoría del banco de preguntas

> Fecha de auditoría: 2026-04-27
> Auditor: revisión manual sobre `supabase/seed.sql` y `supabase/migrations/003-012`

---

## TL;DR

- **Conteo real:** 305 preguntas. `QUESTION_INVENTORY.md` está desactualizado (dice 105). **Actualizar inventario es la primera tarea.**
- **Ningún `correct_key` factualmente incorrecto** detectado. No hay bloqueantes de lanzamiento por contenido erróneo.
- **Problema sistémico: la calidad de las explicaciones es desigual entre batches.** Batch 2 (migrations 008–012) es excelente. Batch 1 (seed + 003–007) tiene explicaciones más débiles que **enseñan menos** porque no descomponen por qué cada distractor es incorrecto.
- **Decisión recomendada para esta semana:** **NO** reescribir batch 1 de cero. En su lugar, corre la app con el banco actual, instrumenta PostHog, y observa qué preguntas reciben más respuestas incorrectas o más "flag for review". Reescribe sólo las top 20 con peor performance después de los primeros 20-30 usuarios reales.

---

## 1. Conteo real por archivo

| Archivo | Dominio | Preguntas | Notas |
|---|---|---|---|
| `seed.sql` | Mix (5 por dominio) + 4 más por dominio | 25 | Calidad batch 1 |
| `003_questions_domain_1.sql` | 1.0 | 11 | Calidad batch 1 |
| `004_questions_domain_2.sql` | 2.0 | 22 | Calidad batch 1 |
| `005_questions_domain_3.sql` | 3.0 | 17 | Calidad batch 1 |
| `006_questions_domain_4.sql` | 4.0 | 29 | Calidad batch 1 |
| `007_questions_domain_5.sql` | 5.0 | 19 | Calidad batch 1 |
| `008_questions_domain_1_batch2.sql` | 1.0 | 21 | **Calidad batch 2 (gold standard)** |
| `009_questions_domain_2_batch2.sql` | 2.0 | 40 | Calidad batch 2 |
| `010_questions_domain_3_batch2.sql` | 3.0 | 33 | Calidad batch 2 |
| `011_questions_domain_4_batch2.sql` | 4.0 | 51 | Calidad batch 2 |
| `012_questions_domain_5_batch2.sql` | 5.0 | 37 | Calidad batch 2 |
| **TOTAL** | | **305** | |

Distribución por dominio (oficial vs actual):

| Dominio | Total preguntas | % bank | % oficial SY0-701 | Delta |
|---|---|---|---|---|
| 1.0 General Security Concepts | 41 | 13.4% | 12% | +1.4% |
| 2.0 Threats, Vulnerabilities & Mitigations | 71 | 23.3% | 22% | +1.3% |
| 3.0 Security Architecture | 60 | 19.7% | 18% | +1.7% |
| 4.0 Security Operations | 89 | 29.2% | 28% | +1.2% |
| 5.0 Security Program Management | 60 | 19.7% | 20% | -0.3% |

**Distribución alineada con los pesos oficiales en menos de 2 puntos. No hace falta tocar.**

---

## 2. Diferencia entre batches (la pieza más importante)

Comparación de cómo cada batch trata las explicaciones para el mismo tipo de pregunta:

### Batch 1 — patrón típico (seed.sql:30-32)

> Stem: "Which cryptographic concept ensures that a sender cannot deny having sent a message?"
> Correct: Non-repudiation
> Explicación: "Non-repudiation ensures that a party cannot deny... **Confidentiality protects data, integrity ensures data has not been altered, and availability ensures systems are accessible.**"

Define el correcto. Define los distractores en abstracto. **No dice por qué cada distractor sería incorrecto en este contexto específico.**

### Batch 2 — patrón típico (008_questions_domain_1_batch2.sql:43-49)

> Stem: "An organization stores copies of employees' encryption private keys with a trusted third party..."
> Correct: Key escrow
> Explicación: "Key escrow is the practice of storing copies of cryptographic keys with a trusted third party to enable data recovery. **A is wrong because** key stretching strengthens weak keys or passwords by running them through additional iterations. **C is wrong because** key exchange is the process of securely sharing keys between parties (e.g., Diffie-Hellman). **D is wrong because** key rotation is the periodic replacement of keys to limit exposure."

Define el correcto. **Refuta cada distractor explícitamente, en el contexto del escenario.** Esto es lo que enseña.

**Si tuvieras que armonizar, batch 2 es el target.**

---

## 3. P0 — Bloqueantes de lanzamiento

**Ninguno.** No detecté ningún `correct_key` factualmente incorrecto en las 305 preguntas. Todas las respuestas marcadas como correctas son defensibles según los objetivos oficiales SY0-701.

---

## 4. P1 — Calidad de explicaciones (no bloqueante, pero erosiona valor a mediano plazo)

**Patrón:** ~80 de las 98 preguntas de batch 1 tienen el mismo defecto: la explicación define los distractores en abstracto pero no los refuta en el contexto específico. Esto reduce el valor pedagógico.

**No voy a listar las 80 una por una** — sería ruido. En su lugar, listo los **archivos completos a refactorizar** y los criterios de aceptación.

| Archivo | Preguntas a revisar | Patrón a aplicar |
|---|---|---|
| `seed.sql` | Las 25 (excepto las 5 originales si las dejas como teaser) | Reescribir explicación: "[Correct] is correct because... A is wrong because... B is wrong because... C is wrong because..." |
| `003_questions_domain_1.sql` | Las 11 | Igual |
| `004_questions_domain_2.sql` | Las 22 | Igual |
| `005_questions_domain_3.sql` | Las 17 | Igual |
| `006_questions_domain_4.sql` | Las 29 | Igual |
| `007_questions_domain_5.sql` | Las 19 | Igual |
| `008-012_*_batch2.sql` | **No tocar.** Ya están al estándar. |

**Criterio de aceptación de la reescritura:**
1. La explicación debe mencionar cada uno de los 4 keys (A, B, C, D) explícitamente.
2. Para cada distractor incorrecto, debe explicar **en el contexto del escenario** por qué falla — no solo definirlo en abstracto.
3. La explicación debe poder leerse sin ver la pregunta y aún así enseñar el concepto.
4. Longitud objetivo: 100-300 caracteres por opción discutida (similar a batch 2).

---

## 5. P1 — Inconsistencias menores que pueden confundir

### 5.1 Terminología SY0-601 vs SY0-701 en pen-testing

Batch 1 usa "white-box / black-box / gray-box". Batch 2 usa la nomenclatura oficial SY0-701: "**Known environment / Unknown environment / Partially known environment**". El examen actual usa la nueva nomenclatura aunque acepta la vieja.

**Acción:** En `seed.sql:230-238` y `007_questions_domain_5.sql:158-166` añadir el nuevo término entre paréntesis o reescribir el stem para usar la nomenclatura nueva como principal.

### 5.2 "Credential replay" vs "Replay attack"

`seed.sql:200-208` usa "Credential replay" como respuesta correcta. `009_questions_domain_2_batch2.sql:188` usa "Replay attack". Son sinónimos pero el examen oficial usa "Replay attack". Un usuario que vea las dos preguntas seguidas puede dudar de cuál es la "correcta".

**Acción:** En `seed.sql:202` cambiar el option text de "Credential replay" a "Replay attack" (o aclarar en el stem que ambos términos refieren a lo mismo).

### 5.3 Backups: Differential vs Incremental aparece dos veces

- `seed.sql:252-260` pregunta "What type of backup strategy only copies files that have changed since the last full backup?" → Differential ✓
- `005_questions_domain_3.sql:188-197` pregunta "Which backup type copies only the files that have changed since the last backup of ANY type?" → Incremental ✓

Ambas son correctas y se complementan, pero sin SM-2 o intercalado pueden caer juntas y sentirse repetitivas. **No es un error, sólo flag.**

### 5.4 OAuth descrito como "authentication protocol"

`006_questions_domain_4.sql:236-244` introduce OAuth con "Which authentication protocol is an open standard...". OAuth es estrictamente authorization (la explicación lo aclara, pero el stem tiene la palabra "authentication"). El examen Sec+ es a menudo laxo aquí, pero un usuario técnicamente preciso podría marcarlo como confuso.

**Acción:** Cambiar "authentication protocol" por "open-standard protocol" en el stem.

### 5.5 Stem de VPC un poco débil

`seed.sql:207-211` define VPC como "An isolated section of a public cloud for a single organization". Técnicamente es correcto pero la palabra "single organization" es restrictiva (VPCs pueden compartirse vía peering/RAM en AWS). **No reescribir, sólo flag.**

---

## 6. P2 — Estilo / pulido (deja para después de las primeras ventas)

- Algunas preguntas marcadas `hard` son en realidad `medium` (ej. ABAC, RBAC). Recalibrar después de tener data de PostHog.
- Inconsistencia menor de mayúsculas en tags (`obj-1.1` vs `obj-1.4`) — homogéneo pero verifica.
- Algunas explicaciones de batch 2 son largas (>500 chars). Funciona pero podría partirse en 2-3 frases más cortas para mejor lectura móvil.

---

## 7. Recomendación pragmática para el sprint de 1 semana

**No hagas la reescritura masiva de batch 1 esta semana.** Es 80+ preguntas, ~6 horas de trabajo bien hecho, y no es lo que más mueve la aguja del lanzamiento.

En su lugar:

1. **Hoy (30 min):** Aplica los 4 fixes P1 puntuales de la sección 5 (terminología known/unknown, replay attack, OAuth wording). Son line-edits, no reescrituras.
2. **Hoy (10 min):** Actualiza `QUESTION_INVENTORY.md` para reflejar las 305 reales en lugar de 105.
3. **Esta semana:** Lanza con el banco actual. Instrumenta `question_id` en el evento `quiz_session_completed` de PostHog (junto con `is_correct`).
4. **Semana 2 (post-launch):** Identifica las 20 preguntas con mayor `% incorrecto` o más "flagged for review". **Esas** son las que reescribes al estándar de batch 2 — datos en lugar de intuición.
5. **Semana 3+:** Continúa la armonización en orden de impacto.

El razonamiento: batch 1 no enseña tan bien como batch 2, pero es **factualmente correcto**. No vas a perder ventas por explicaciones flojas la primera semana — vas a perder ventas por funnel roto, pricing confuso, o checkout que falla. Atiende eso primero, y deja que los usuarios reales te digan cuáles preguntas duelen más.

---

## 8. Apéndice — Plantilla para reescritura de batch 1

Cuando llegue el momento (semana 2-3), usa esta plantilla:

```
[CORRECT_OPTION_TEXT] is the correct answer because [scenario-specific reasoning that maps the stem to the concept].

A is wrong because [definition of option A] [why it does not fit this specific scenario].
B is wrong because [definition of option B] [why it does not fit this specific scenario].
C is wrong because [definition of option C] [why it does not fit this specific scenario].
[Skip the line for the correct option, or merge it with the opening sentence.]
```

Ejemplo, reescribiendo `seed.sql:30-32` al estándar:

> **Original:** "Non-repudiation ensures that a party cannot deny... Confidentiality protects data, integrity ensures data has not been altered, and availability ensures systems are accessible."
>
> **Reescrita:** "Non-repudiation ensures that a party cannot deny the authenticity of a message they sent — typically achieved through digital signatures using asymmetric cryptography. A is wrong because confidentiality protects data from unauthorized disclosure, which doesn't address whether the sender can deny the message. B is wrong because integrity ensures data has not been altered in transit but doesn't bind the message to a specific sender. D is wrong because availability ensures systems are accessible, which is unrelated to sender accountability."
