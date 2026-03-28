---
name: review-pr
description: "Review a pull request comparing two branches. Invoke with /review-pr <source-branch> <target-branch>. Example: /review-pr feature/auth main"
user-invocable: true
argument-hint: "<source-branch> [target-branch=main]"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Agent"]
---

# PR Review: $ARGUMENTS

## Parse Arguments

Parse the arguments to extract:
- **Source branch**: first argument (required)
- **Target branch**: second argument (defaults to `main`)

If no arguments provided, use the current branch as source and `main` as target.

## Review Workflow

### 1. Gather Context

Run these in parallel:

- `gh pr list --head <source-branch> --base <target-branch> --json number,title,body,state,url` to find the PR
- `git diff <target-branch>...<source-branch> --stat` to get a summary of changed files
- `git log <target-branch>...<source-branch> --oneline` to see all commits included

If no PR exists, review the diff between branches directly.

### 2. Get the Full Diff

- Run `git diff <target-branch>...<source-branch>` to get all changes
- Identify which feature modules are affected (`features/`, `shared/`, `app/`)
- Note file types: components, API routes, lib utilities, types, tests, config

### 3. Read CLAUDE.md and AGENTS.md

Read the project's CLAUDE.md and AGENTS.md to understand project conventions. Any review must check compliance with these rules.

### 4. Launch Parallel Review Agents

Launch 4 agents in parallel, each with the full diff context and list of changed files:

**Agent 1 — Bug & Logic Review (Sonnet)**
- Read each changed file fully
- Look for: logic errors, null/undefined issues, race conditions, missing await, incorrect types, security vulnerabilities (XSS, injection, exposed secrets)
- For Supabase queries: check RLS policies, missing `.single()`, unhandled errors
- For Stripe integrations: check webhook signature verification, idempotency
- For Next.js: check server/client boundary violations, missing `'use client'` directives
- Score each finding 0-100. Only report >= 80.

**Agent 2 — Architecture & Conventions (Sonnet)**
- Verify feature-based architecture: code in correct module (`features/auth`, `features/quiz`, `features/billing`, `features/progress`)
- Check imports follow the `@/*` alias pattern
- Verify shared code is in `shared/lib` or `shared/types`
- Check CLAUDE.md and AGENTS.md compliance
- Verify Next.js App Router conventions (layout.tsx, page.tsx, loading.tsx, error.tsx)
- Score each finding 0-100. Only report >= 80.

**Agent 3 — Error Handling & Silent Failures (Sonnet)**
- Find all try-catch blocks, `.catch()`, error callbacks
- Check: empty catch blocks, swallowed errors, generic error messages
- Verify Supabase calls check `error` return values
- Verify Stripe webhook handlers have proper error responses
- Verify API routes return appropriate HTTP status codes
- Score each finding 0-100. Only report >= 80.

**Agent 4 — Test Coverage & Quality (Sonnet)**
- Check if new functionality has corresponding tests
- Verify edge cases are covered (empty states, error states, boundary values)
- Check test quality: testing behavior not implementation
- For SM2 algorithm changes: verify spaced repetition edge cases
- Note missing tests for critical paths
- Score each finding 0-100. Only report >= 80.

### 5. Filter & Validate

For each issue found across all agents:
- Discard scores below 80
- Discard pre-existing issues (not introduced in this diff)
- Discard issues a linter/typechecker/compiler would catch
- Discard stylistic nitpicks not explicitly in CLAUDE.md
- Merge duplicate findings from different agents

### 6. Output Format

```markdown
## PR Review: <PR title or branch name>

**Branch:** `<source>` -> `<target>`
**Files changed:** X | **Commits:** Y

---

### Critical Issues (score 90-100)

1. **[Bug/Architecture/Error/Test]** <description>
   `file/path.ts:LINE` — <explanation and fix suggestion>

### Important Issues (score 80-89)

1. **[Bug/Architecture/Error/Test]** <description>
   `file/path.ts:LINE` — <explanation and fix suggestion>

### Strengths

- What this PR does well

### Verdict

[ ] APPROVE — No critical issues, good to merge
[ ] REQUEST CHANGES — Critical issues must be fixed
[ ] COMMENT — Important issues to consider
```

### 7. Post to PR (Optional)

If a GitHub PR exists and issues were found, ask the user if they want to post the review as a PR comment using `gh pr comment`.

## False Positive Guide

Do NOT flag:
- Pre-existing issues not introduced in this diff
- Issues that linters, TypeScript, or ESLint would catch
- Pedantic style preferences not in CLAUDE.md
- Intentional functionality changes related to the PR's purpose
- General code quality suggestions (unless CLAUDE.md requires them)
- Lines the author did not modify
