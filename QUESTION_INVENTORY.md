# Question Inventory — CompTIA Security+ (SY0-701)

Last updated: 2026-04-06

## Exam Domains & Official Weights

| Domain | Name | Official Weight |
|--------|------|----------------|
| 1.0 | General Security Concepts | 12% |
| 2.0 | Threats, Vulnerabilities, and Mitigations | 22% |
| 3.0 | Security Architecture | 18% |
| 4.0 | Security Operations | 28% |
| 5.0 | Security Program Management and Oversight | 20% |

## Questions per Domain

| Domain | Seed | Migration | Total | % of Bank | Official Weight | Delta |
|--------|------|-----------|-------|-----------|----------------|-------|
| 1.0 | 5 | 11 | **16** | 15.2% | 12% | +3.2% |
| 2.0 | 5 | 22 | **27** | 25.7% | 22% | +3.7% |
| 3.0 | 5 | 17 | **22** | 21.0% | 18% | +3.0% |
| 4.0 | 5 | 29 | **34** | 32.4% | 28% | +4.4% |
| 5.0 | 5 | 19 | **24** | 22.9% | 20% | +2.9% |
| **Total** | **25** | **98** | **105** | | | |

## Source Files

- `supabase/seed.sql` — 25 sample questions (5 per domain)
- `supabase/migrations/003_questions_domain_1.sql` — 11 questions (Domain 1.0)
- `supabase/migrations/004_questions_domain_2.sql` — 22 questions (Domain 2.0)
- `supabase/migrations/005_questions_domain_3.sql` — 17 questions (Domain 3.0)
- `supabase/migrations/006_questions_domain_4.sql` — 29 questions (Domain 4.0)
- `supabase/migrations/007_questions_domain_5.sql` — 19 questions (Domain 5.0)

## Notes

- Distribution is reasonably aligned with official exam weights (~3-4% over per domain, relative proportions correct).
- For a production-ready spaced repetition bank, target 300-500 questions to reduce repetition.
