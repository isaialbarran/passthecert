# PassTheCert — Agent Team

This folder contains **founder-facing pointer stubs** for every agent role. The canonical spec for each role is the `SKILL.md` in `.claude/skills/<name>/` — that's what Claude Code actually invokes. The stubs here exist so a human can paste a short role description into Claude chat or a Claude Project without opening the skill file.

## Prerequisites
Before using the agent workflow, ensure these exist:
- **`INSTRUCTIONS.md`** — the MVP specification. Every agent references it as the source of truth.
- **`CLAUDE.md`** — stack, architecture rules, language rule. Every agent inherits it.
- **`docs/stack-setup.md`** — pending-install dependencies (Shadcn/UI, TanStack Query, Zod, Playwright) and install commands.

## Team roster

Slash commands listed below are invocable via Claude Code. Unless noted, every skill is `user-invocable: true`.

| Agent | Stub | Skill | Slash command | Responsibility |
|---|---|---|---|---|
| Product Manager | `product.md` | `.claude/skills/product/` | `/product` | User stories, prioritization, roadmap |
| Business Analyst | `ba.md` | `.claude/skills/ba/` | `/ba` | Technical specs, Zod schemas, data models |
| Designer | `design.md` | `.claude/skills/design/` | `/design` | UI components, design system, Tailwind code |
| Developer | `dev.md` | — (Claude Code itself) | — | Feature implementation, migrations, PRs |
| QA | `qa.md` | `.claude/skills/qa/` | `/qa` | Test plans, Playwright tests, SQL verification |
| Architect | `architect.md` | `.claude/skills/architect/` | `/architect` | Application-code review: DRY, scalability, best practices |
| DB Review | `db-review.md` | `.claude/skills/db-review/` | `/db-review` | Schema, RLS, triggers, indexes audit |
| Security | — | `.claude/skills/security/` | `/security` | RLS coverage, secrets, auth, webhook signature audit *(founder-invoked)* |
| Content | — | `.claude/skills/content/` | `/content` | Security+ question-bank expansion as SQL *(founder-invoked)* |
| Growth / Marketing | `marketing.md` | `.claude/skills/marketing/` | `/marketing` | GTM plans, channel copy, positioning, tracking audit |
| Ship | `ship.md` | `.claude/skills/ship/` | `/ship` | Rebase, commit, push, open PR *(founder-invoked)* |
| Review PR | — | `.claude/skills/review-pr/` | `/review-pr` | Senior-level PR review |

Rows marked *(founder-invoked)* have `disable-model-invocation: true` in the skill frontmatter — the model won't auto-call them on casual prompts.

## How to use each agent

### In Claude Code (terminal)
Invoke any skill by its slash command:

```bash
claude

# Inside the session:
/product add a "review mistakes" mode to the quiz
/ba review-mistakes-mode
/design review-mistakes-card
/qa features/quiz
/architect features/quiz
/db-review quiz_sessions
/security full
```

The Dev role is Claude Code itself — just prompt it with the BA spec and it will implement.

### In Claude chat / Claude Projects
Claude chat can't execute slash commands, so you paste both files as context:

1. Open `AGENTS/<role>.md` — copy the ~15-line stub
2. Open the matching `.claude/skills/<role>/SKILL.md` — copy its body
3. Paste both into a Claude Project as the system prompt
4. Add `INSTRUCTIONS.md` and `CLAUDE.md` as Project documents

## Workflow per feature

```
1. /product       → user story + acceptance criteria
2. /ba            → technical spec + data model + Zod schemas
3. /design        → UI component (Tailwind + Shadcn/UI)
4. Dev (Claude Code) → implement feature using BA spec + Design component
5. /qa             → test plan + Playwright tests  ┐ can run
6. /architect      → code quality review            ┘ concurrently
7. /db-review      → if migration touched schema/RLS
8. /security       → before every launch milestone
9. /ship           → rebase, commit, push, open PR
10. /review-pr     → senior review of the open PR
11. Founder       → review, approve, merge
```

## Ground rules
- **`CLAUDE.md` and `INSTRUCTIONS.md` are the constitution.** No agent overrides them.
- **One feature at a time.** Don't parallelize until the workflow is stable.
- **GitHub Issues = task queue.** Every task starts as an Issue, every output closes it.
- **You merge all PRs.** Agents propose, you dispose.
- **Stubs stay stubs.** If a rule needs to change, change it in the `SKILL.md`. AGENTS stubs contain zero normative rules.
