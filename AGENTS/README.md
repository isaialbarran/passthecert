# PassTheCert — Agent Team

This folder contains the system prompts for the AI agent team building PassTheCert.
Each file defines a role. You (the founder) are the orchestrator.

## Prerequisites
Before using the agent workflow, ensure these exist:
- **`SPEC.md`** — the MVP specification. Every agent references it as the source of truth. Create it at the repo root before starting any feature work.
- **Dependencies** — some stack dependencies (Shadcn/UI, TanStack Query, Zod, Playwright) are approved but not yet installed. See `AGENTS/dev.md` → "Pending setup" for install commands.

## Team roster

| Agent | File | Tool | Responsibility |
|---|---|---|---|
| Product Manager | `product.md` | Claude (chat) | User stories, prioritization, roadmap |
| Business Analyst | `ba.md` | Claude (chat) | Requirements, acceptance criteria, data models |
| Designer | `design.md` | Claude (chat) | UI components, design system, Tailwind code |
| Developer | `dev.md` | Claude Code | Feature implementation, migrations, PRs |
| QA | `qa.md` | Claude (chat) | Test plans, bug reports, Playwright tests |
| Architect | `architect.md` | Claude (chat) | Code review, scalability, DRY, best practices |

## How to use each agent

### In Claude chat (this interface)
Start your message by pasting the agent's `.md` content as context, then give the task.
Or use Claude Projects — create one Project per agent and paste the `.md` as the system prompt.

**Recommended: Claude Projects setup**
1. Create a Project called "PassTheCert — Product"
2. Add `product.md` content as the Project instructions
3. Add `SPEC.md` as a Project document (create it first — see Prerequisites above)
4. Repeat for each role

### In Claude Code (terminal)
```bash
# The dev agent runs via Claude Code with SPEC.md and dev.md as context
claude

# Inside the Claude Code session, reference the agent:
# "You are the Dev agent defined in AGENTS/dev.md. 
#  Read SPEC.md and implement step 7: features/quiz/sm2.ts"
```

## Workflow per feature

```
1. PM agent       → Write user story + acceptance criteria
2. BA agent       → Write technical spec + data model + API contract
3. Design agent   → Build UI component
4. Dev agent      → Implement feature using BA spec + Design component
5. QA agent       → Write test plan + run tests against Dev's output      ┐ can run
6. Architect agent → Review code quality, duplicity, scalability           ┘ concurrently
7. You            → Review, approve, merge PR
```

## Ground rules
- **SPEC.md is the constitution.** No agent overrides it without your approval.
- **One feature at a time.** Don't parallelize until you have the workflow stable.
- **GitHub Issues = task queue.** Every task starts as an Issue, every output closes it.
- **You merge all PRs.** Agents propose, you dispose.
