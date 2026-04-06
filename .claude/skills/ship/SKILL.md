---
name: ship
description: "Rebase from main, commit all changes, push, and open a pull request. Usage: /ship [commit message]"
user-invocable: true
disable-model-invocation: true
argument-hint: "[commit message]"
allowed-tools: ["Bash", "Read", "Glob", "Grep"]
---

# Ship: rebase, commit, push, and open PR

## Context

**Current branch:**
!`git branch --show-current`

**Git status:**
!`git status --short`

**Recent commits on this branch (not on main):**
!`git log --oneline origin/main..HEAD 2>/dev/null || echo "(no commits ahead of main)"`

**Staged + unstaged diff summary:**
!`git diff --stat HEAD 2>/dev/null`

## Workflow

Execute these steps in order. Stop and report to the user if any step fails unexpectedly.

### 1. Validate

- If there are no changes to commit AND no commits ahead of main, tell the user there is nothing to ship and stop.
- Detect the current branch name. If on `main`, tell the user to create a branch first and stop.

### 2. Rebase from main

```
git fetch origin main
git rebase origin/main
```

- If the rebase has conflicts, list the conflicted files and ask the user how to proceed. Do NOT force-resolve or abort without asking.
- If the rebase succeeds, continue.

### 3. Commit

- If there are uncommitted changes (staged or unstaged):
  - Run `git status` and `git diff` to understand what changed.
  - Stage the relevant files individually (`git add <file>` — avoid `git add -A` to prevent accidentally committing secrets or build artifacts). Never stage `.env*` files.
  - If `$ARGUMENTS` was provided, use it as the commit message.
  - If no argument was provided, analyze the diff and draft a conventional commit message (e.g., `feat:`, `fix:`, `docs:`, `refactor:`). Show it to the user for confirmation before committing.
  - Always append the co-author trailer:
    ```
    Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>
    ```
  - Use a HEREDOC to pass the message to `git commit -m`.
- If there are no uncommitted changes but there are already commits ahead of main, skip this step.

### 4. Push

```
git push -u origin <branch-name>
```

- If the push is rejected (e.g., after rebase), ask the user before using `--force-with-lease`. Never use `--force`.

### 5. Open PR

- First check if a PR already exists for this branch: `gh pr view --json url 2>/dev/null`
- If a PR exists, show the URL and skip PR creation.
- If no PR exists, create one:
  - Analyze ALL commits on this branch (not just the latest) to draft the PR title and body.
  - Keep the title under 70 characters, use conventional format.
  - Use this body template:

```
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-4 bullet points covering all commits>

## Test plan
<Checklist of what to verify>

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### 6. Report

Output the PR URL and a one-line summary of what was shipped.
