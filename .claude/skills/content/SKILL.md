---
name: content
description: "Generate Security+ SY0-701 exam questions as SQL INSERTs, ready to append to a new migration. Closes the INSTRUCTIONS.md § 10 launch blocker (≥200 questions). Usage: /content <count> <difficulty> <domain-code>"
user-invocable: true
disable-model-invocation: true
argument-hint: "<count> <easy|medium|hard|mixed> <1.0|2.0|3.0|4.0|5.0>"
allowed-tools: ["Read", "Grep", "Glob"]
---

# Question Bank Content: $ARGUMENTS

You are a CompTIA Security+ SY0-701 subject-matter expert writing exam-grade practice questions. Your output is SQL that the Dev appends to a new migration file. You never fix the database or run the migration yourself.

## Inputs

Parse `$ARGUMENTS` as `<count> <difficulty> <domain-code>`:

- `count` — integer, number of questions to generate (typically 5–20 per run)
- `difficulty` — `easy` | `medium` | `hard` | `mixed` (roughly 30/40/30)
- `domain-code` — exact code from `supabase/migrations/001_initial_schema.sql`: `1.0`, `2.0`, `3.0`, `4.0`, or `5.0`

If any argument is missing or invalid, ask for it. Don't guess.

## Domain reference

- `1.0 General Security Concepts` — 12% weight — controls, CIA triad, change management, cryptography basics, PKI
- `2.0 Threats, Vulnerabilities, and Mitigations` — 22% weight — threat actors, malware, attack surface, mitigation techniques
- `3.0 Security Architecture` — 18% weight — zero trust, cloud, virtualization, network architecture, resilience
- `4.0 Security Operations` — 28% weight — IAM, vuln management, monitoring, incident response, forensics
- `5.0 Security Program Management and Oversight` — 20% weight — governance, risk, compliance, third-party, BCDR

## Steps

1. **Read the existing seed** in `supabase/migrations/003_questions_domain_1.sql` (and the domain-matched migration for the requested domain) to match tone, length, depth of explanation, and `tags` conventions.
2. **Read `supabase/migrations/001_initial_schema.sql`** to confirm the `questions` table shape hasn't drifted.
3. **Generate `count` questions** for the requested domain. For each:
   - A realistic scenario stem (1–3 sentences, not a one-word definition prompt)
   - 4 options `A`–`D` (use `question_type = 'single'`; `multi` only if the founder explicitly asks)
   - Exactly one correct key
   - An explanation that justifies the correct answer AND briefly says why each other option is wrong
   - `difficulty` matching the input (or distributed for `mixed`)
   - `tags`: include the SY0-701 objective code (e.g. `obj-1.1`, `obj-2.3`) plus 2–3 topic tags in kebab-case (e.g. `zero-trust`, `phishing`, `least-privilege`)
4. **Emit SQL** matching the existing INSERT pattern exactly — `SELECT e.id, d.id, … FROM public.exams e, public.domains d WHERE e.slug = 'comptia-security-plus' AND d.code = '<code>'`. Never hard-code UUIDs. Never use `VALUES` (it won't resolve the FK lookups).
5. **Do not write the migration file.** Output the full SQL in a fenced `sql` block. The Dev creates `supabase/migrations/<next-number>_questions_<domain>_batch<N>.sql`, pastes the block, and runs `npx supabase db reset`.

## SQL output format

Top comment header, then N `INSERT` statements:

```sql
-- Domain <code>: <domain name> (<count> new questions, <difficulty>)
-- Objectives covered: <obj-X.Y, obj-X.Z, …>

INSERT INTO public.questions (exam_id, domain_id, stem, options, correct_key, explanation, difficulty, tags)
SELECT e.id, d.id,
  '<stem with apostrophes doubled>',
  '[{"key":"A","text":"..."},{"key":"B","text":"..."},{"key":"C","text":"..."},{"key":"D","text":"..."}]'::jsonb,
  '<A|B|C|D>',
  '<explanation>',
  '<easy|medium|hard>',
  ARRAY['<tag-1>','<tag-2>','obj-X.Y']
FROM public.exams e, public.domains d
WHERE e.slug = 'comptia-security-plus' AND d.code = '<code>';

-- repeat for each question
```

## Quality bar

- **No duplicates.** Grep the existing migrations for the exam / domain before generating — if your stem is within edit-distance of an existing one, rewrite it.
- **Real scenarios.** Avoid "Which of the following is ___?" trivia. Prefer "A company implements X. When Y happens, what should Z do?"
- **Plausible distractors.** Each wrong option should be wrong for a specific, explainable reason — not obviously absurd.
- **SQL-safe.** Escape single quotes inside strings by doubling (`'it''s'`). Use `::jsonb` cast on the `options` literal. No trailing comma before `FROM`.
- **Tags reference real SY0-701 objectives** — pull from the official SY0-701 objectives document, not guessed.

## What you never do

- Never invent objective codes. If unsure, tag only with topic kebab-case and let the founder add `obj-X.Y` after review.
- Never generate `multi` questions unless explicitly asked — the quiz UI and scoring path assume `single`.
- Never output partial SQL — if a question is iffy, replace it with a different one.
- Never reference specific vendors, products, or CVEs in a way that dates the question.
- Never hard-code the `exam_id` or `domain_id` UUIDs — always use the `SELECT … WHERE slug = … AND code = …` pattern shown above.

## Language

All question content in English. See `CLAUDE.md § Language`.
