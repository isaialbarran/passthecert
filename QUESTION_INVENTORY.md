# Question Inventory — CompTIA Security+ (SY0-701)

Last updated: 2026-04-27

## Exam Domains & Official Weights

| Domain | Name | Official Weight |
|--------|------|----------------|
| 1.0 | General Security Concepts | 12% |
| 2.0 | Threats, Vulnerabilities, and Mitigations | 22% |
| 3.0 | Security Architecture | 18% |
| 4.0 | Security Operations | 28% |
| 5.0 | Security Program Management and Oversight | 20% |

## Questions per Domain

| Domain | Seed | Batch 1 | Batch 2 | Total | % of Bank | Official Weight | Delta |
|--------|------|---------|---------|-------|-----------|----------------|-------|
| 1.0 | 5 | 11 | 21 | **37** | 12.1% | 12% | +0.1% |
| 2.0 | 5 | 22 | 40 | **67** | 21.8% | 22% | -0.2% |
| 3.0 | 5 | 17 | 33 | **55** | 17.9% | 18% | -0.1% |
| 4.0 | 5 | 29 | 53 | **87** | 28.3% | 28% | +0.3% |
| 5.0 | 5 | 19 | 37 | **61** | 19.9% | 20% | -0.1% |
| **Total** | **25** | **98** | **184** | **307** | | | |

> Distribution is within ±0.3% of the official SY0-701 weights — no rebalancing needed.

## Source Files

### Seed (25 questions, 5 per domain)
- `supabase/seed.sql`

### Batch 1 — pedagogical floor (98 questions)
- `supabase/migrations/003_questions_domain_1.sql` — 11 questions (Domain 1.0)
- `supabase/migrations/004_questions_domain_2.sql` — 22 questions (Domain 2.0)
- `supabase/migrations/005_questions_domain_3.sql` — 17 questions (Domain 3.0)
- `supabase/migrations/006_questions_domain_4.sql` — 29 questions (Domain 4.0)
- `supabase/migrations/007_questions_domain_5.sql` — 19 questions (Domain 5.0)

### Batch 2 — gold standard (184 questions)
Each explanation refutes every distractor in the scenario context (see `QUESTION_AUDIT.md` §2).
- `supabase/migrations/008_questions_domain_1_batch2.sql` — 21 questions (Domain 1.0)
- `supabase/migrations/009_questions_domain_2_batch2.sql` — 40 questions (Domain 2.0)
- `supabase/migrations/010_questions_domain_3_batch2.sql` — 33 questions (Domain 3.0)
- `supabase/migrations/011_questions_domain_4_batch2.sql` — 53 questions (Domain 4.0)
- `supabase/migrations/012_questions_domain_5_batch2.sql` — 37 questions (Domain 5.0)

## Notes

- Original target: 200 questions. Stretch: 300. **Both exceeded** at 307.
- Audit (`QUESTION_AUDIT.md`, 2026-04-27) found zero factually-incorrect `correct_key` values — no P0 content blockers for launch.
- Batch 1 explanations are weaker than batch 2 (define distractors abstractly, don't refute in scenario context). Rewrite is **deferred to post-launch** and prioritized by PostHog `% incorrect` data, not intuition. See `LAUNCH_PLAN.md` Stretch.
