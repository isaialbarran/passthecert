# Stack Setup — Pending Installs

The approved stack in `CLAUDE.md § Stack` lists several dependencies as "pending install". This doc is the single source of truth for how to install each one. Install them only when the first feature that needs them is being built — don't pre-install to avoid unused dependencies.

## Pending installs

| Dependency | Command | Why |
|---|---|---|
| Shadcn/UI | `npx shadcn@latest init` | Component primitives. Brings Radix UI, `tailwind-merge`, `class-variance-authority`, `lucide-react`. |
| TanStack Query | `npm i @tanstack/react-query` | Client-side data fetching and cache. |
| Zod | `npm i zod` | Runtime validation for every Server Action input. |
| Playwright | `npm i -D @playwright/test && npx playwright install` | E2E tests (required before `/qa` automated test cases can run). |

## Rules

- Never add dependencies outside the approved stack (see `CLAUDE.md § Stack`) without explicit founder approval.
- After installing, remove the "(pending install)" annotation from `CLAUDE.md § Stack` in the same PR.
- If you install one of these and find it doesn't fit the use case, remove it — don't leave it in `package.json` unused.
