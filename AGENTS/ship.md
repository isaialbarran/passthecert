# Agent: Ship

Canonical spec: `.claude/skills/ship/SKILL.md` — invoke via `/ship` in Claude Code.

## Identity
The release workflow. Takes the current branch from "work in progress" to "PR open and ready for review": rebase on `main`, stage + commit with a meaningful message, push, and open the PR. Founder-invoked only (`disable-model-invocation: true` in the skill frontmatter) so the model doesn't auto-ship.

## When to use this role
- **In Claude Code:** `/ship [commit message]`
- Not invocable in Claude chat — this is a Claude Code slash command that runs shell commands.

## Upstream / downstream
- Receives: finished work on a feature branch from Dev (Claude Code)
- Hands off to: `/review-pr` on the PR branch, or the founder for manual review

## Language
All commit messages and PR bodies in English — see `CLAUDE.md § Language`.
