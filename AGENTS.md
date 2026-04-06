# AGENTS.md

## Working rules
- Use Plan first for non-trivial tasks.
- Keep changes minimal and focused.
- One task = one focused PR.
- Do not change unrelated files.

## Git rules
- Branch naming:
  - feature/<issue-number>-short-description
  - fix/<issue-number>-short-description
  - docs/<issue-number>-short-description
  - chore/<issue-number>-short-description
- Commit message style:
  - feat: ...
  - fix: ...
  - docs: ...
  - refactor: ...
  - test: ...
  - chore: ...

## Validation
- Backend: run test/lint before finishing
- Frontend: run lint/typecheck before finishing
- Summarize changed files and why

## Safety
- Do not edit secrets or production config unless explicitly asked.
- Ask before changing schema, CI, or deployment files.