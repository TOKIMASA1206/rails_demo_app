---
name: nextjs-frontend-implementation
description: Implement focused Next.js frontend changes in a repository. Use when Codex needs to add or refactor frontend pages, components, forms, API calls, UI states, tests, or validation workflows, especially for Issue-driven work that should follow repository frontend guidelines such as docs/guidelines/frontend.md and preserve existing UI patterns.
---

# Frontend Implementation

## Overview

Use this skill to make frontend changes that are small, reviewable, and aligned with the target Next.js app. Prefer the repository's own frontend guidance when present; this skill turns those guidelines into an execution workflow for Codex.

## Required Reading

Before editing frontend code, read when present:

- `AGENTS.md`
- `frontend/AGENTS.md`, if present
- frontend guidelines such as `docs/guidelines/frontend.md`
- The target files and nearby frontend patterns

When changing Next.js APIs, routing, rendering boundaries, or framework conventions, also read the relevant guide under `frontend/node_modules/next/dist/docs/` if dependencies are installed.

If the task also changes backend/API behavior, read the repository's API/backend guidelines and keep backend work in a separate Issue unless the user explicitly scopes both.

## Working Contract

- Keep one Issue focused on one main goal: UI structure, API helper, form behavior, tests, or polish.
- Prefer the repository's existing Next.js, React, TypeScript, and Tailwind patterns.
- Do not add authentication, maps, image upload, favorites, comments, ratings, sharing, advanced search, notifications, background jobs, or broad abstractions unless explicitly requested or already part of the product scope.
- Avoid unrelated file moves, schema/config changes, or design rewrites.
- Preserve user-visible behavior unless the Issue asks to change it.
- Add the minimum useful abstraction only when it reduces real duplication or clarifies ownership.

## Workflow

1. Orient to the Issue.
   - Confirm the user goal, acceptance criteria, target files, and validation commands.
   - Run `git status --short --branch`.
   - Inspect existing components, types, API calls, and scripts with `rg --files` and `rg`.

2. Choose the implementation shape.
   - Server Component first for static or initial-render data.
   - Client Component only for forms, browser events, local interactive state, or existing client-only flows.
   - Keep `"use client"` in the smallest reasonable component.
   - Do not convert a whole existing client screen to server components unless that is the Issue goal.

3. Plan responsibilities before editing.
   - Separate page composition, data fetching, form state, filtering/sorting state, list item display, and state views when they start competing in one file.
   - Keep feature-specific code near the feature; use shared `src/types` only for types reused across features.
   - Prefer a feature folder such as `src/features/spots/` when the Issue creates a larger reusable surface.

4. Implement in a narrow pass.
   - Keep props small and serializable across server/client boundaries.
   - Keep form initial values, submit values, reset behavior, and disabled state readable.
   - Prevent duplicate submits with an explicit submitting state.
   - Do not leave unused code, placeholder UI, debug logs, or unreachable branches.

5. Handle UI states deliberately.
   - Loading: show a useful pending state when data or submission is in progress.
   - Error: show user-readable recovery context without leaking noisy developer details.
   - Empty: show what the user can do next.
   - Success: update the UI predictably after mutations.
   - Disabled: make unavailable actions clear and keyboard-safe.

6. Connect APIs conservatively.
   - Centralize API base URL, JSON fetch, and HTTP error handling when calls repeat.
   - Keep API helpers small; do not build a general client before the app needs it.
   - Separate server-only helpers from helpers imported by Client Components.
   - Always check `response.ok`.
   - Keep the backend responsible for data integrity, business rules, authorization, and final validation.
   - Treat demo user IDs or headers as temporary development mechanics, not real auth.

7. Preserve the UI tone.
   - Match existing spacing, typography, colors, component density, and Japanese copy style.
   - Use labels for inputs, clear disabled states, and responsive layouts that do not overflow.
   - Keep text action-oriented; avoid explanatory marketing copy inside app screens.
   - Do not introduce decorative UI or large design shifts unless the Issue asks for design work.

8. Add or update tests when risk justifies it.
   - Prioritize tests for loading, error, empty, success, and form submit behavior.
   - Mock `fetch` for component tests that cross the API boundary.
   - If no frontend test setup exists, do not create a large test stack as a side quest; note the gap or use the Issue dedicated to tests.

9. Validate.
   - Run `docker compose exec frontend npm run lint` for frontend changes.
   - Run `docker compose exec frontend npm run build` when changing page structure, routing, env usage, server/client boundaries, or TypeScript/API surfaces.
   - Use a browser check when the change affects visible UI or interaction.
   - If a command cannot run, capture the exact reason and state it in the final summary.

10. Hand off clearly.
    - Summarize changed files and why.
    - Mention validation commands and results.
    - Call out any intentional deferrals, test gaps, or follow-up Issues.

## Review Checklist

Before final response, check:

- Does the change satisfy only this Issue's scope?
- Are Server and Client Component boundaries intentional?
- Are API calls typed, `ok`-checked, and error-handled?
- Are loading, error, empty, success, and disabled states covered where relevant?
- Are secrets and server-only environment variables kept out of browser code?
- Does the UI match the existing app's tone?
- Did lint/build/browser checks run or get clearly explained?
