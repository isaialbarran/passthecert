# PassTheCert — Agent Instructions

> Claude Code reads this file automatically. These rules apply to all subagents launched via the Task tool.

## Next.js 16

This repo uses Next.js 16, which may have breaking changes. If unsure about a specific API, consult `node_modules/next/dist/docs/`. Don't read those docs preemptively — only when needed to avoid wasting tokens.

## Agent roles

This project uses a multi-agent workflow. Detailed prompts for each role live in `AGENTS/*.md`. Here's a summary:

| Role | File | Purpose | Used in |
|------|------|---------|---------|
| Product Manager | `AGENTS/product.md` | User stories, acceptance criteria, prioritization | Claude Projects/chat |
| Business Analyst | `AGENTS/ba.md` | Technical specs, data models, API contracts | Claude Projects/chat |
| Designer | `AGENTS/design.md` | UI components, design system, Tailwind code | Claude Projects/chat |
| Developer | `AGENTS/dev.md` | Feature implementation, migrations | Claude Code |
| QA | `AGENTS/qa.md` | Test plans, bug reports, Playwright tests | Claude Projects/chat |
| Architect | `AGENTS/architect.md` | Code review, scalability, DRY | Claude Projects/chat |

## Workflow per feature

```
1. PM        → User story + acceptance criteria
2. BA        → Technical spec + data model + API contract
3. Designer  → UI component (Tailwind + Shadcn/UI)
4. Dev       → Implement using BA spec + Designer output
5. QA + Architect → Test plan + code review (concurrent)
6. Founder   → Review, approve, merge PR
```

## Rules for subagents (Task tool)

When a subagent is launched in Claude Code:
- It inherits `CLAUDE.md` and this file as context automatically
- It must follow the architecture and code standards in `CLAUDE.md`
- It must read `INSTRUCTIONS.md` (MVP spec) before any feature work
- It must never add dependencies outside the approved stack
- It must never bypass RLS or expose secrets

## How to invoke roles in Claude Code

Use the Task tool with a prompt that assigns the role:

```
Task(subagent_type="Plan", prompt="
  You are the Architect defined in AGENTS/architect.md.
  Review the quiz feature in features/quiz/.
  Check for DRY violations and scalability issues.
")

Task(subagent_type="general-purpose", prompt="
  You are the Dev defined in AGENTS/dev.md.
  Read INSTRUCTIONS.md and implement features/quiz/sm2.ts.
")
```

For PM, BA, Designer, and QA — use **Claude Projects** (web UI) with the role's `.md` file as the project system prompt and `INSTRUCTIONS.md` as a project document.

## Ground rules

- `INSTRUCTIONS.md` is the constitution — no agent overrides it without founder approval
- One feature at a time until the workflow is stable
- GitHub Issues = task queue (every task starts as an Issue)
- Founder merges all PRs — agents propose, founder disposes
