# AGENTS.md


## 1. Project Overview
SpotLog is a Rails API demo app for learning practical Rails development before starting the Visual-English project.

The app allows users to save places they want to visit, organize them by category, and manage their visit status.

Examples of spots:
- cafes
- ramen shops
- bookstores
- hot springs
- tourist spots

Primary goal:
- learn Rails API fundamentals through a realistic but not overly complex app

Secondary goal:
- practice practical development workflow with Issue -> branch -> PR -> review -> merge

---

## 2. MVP Goal
Build a small but complete Rails API app where a user can:

- create a spot
- view a list of spots
- view a single spot
- update a spot
- delete a spot
- filter spots by category

The MVP should feel like a real product, but remain small enough for learning.

---

## 3. Non-goals
Do NOT add these in the initial MVP unless explicitly requested:

- authentication
- authorization
- Google Maps API
- image upload
- favorites
- comments
- rating system
- public/private sharing
- advanced search
- notifications
- background jobs
- premature abstractions

Keep the project intentionally small and focused.

---

## 4. Core Domain Model
Current MVP data model:

- Category has_many Spots
- Spot belongs_to Category

### categories
- id
- name
- created_at
- updated_at

### spots
- id
- category_id
- name
- note
- url
- status
- visited_on
- created_at
- updated_at

### status values
Use a simple status design for MVP:
- want_to_go
- visited

Do not introduce additional statuses unless explicitly needed.

---

## 5. Guideline Loading Rules
Always follow this `AGENTS.md`.

Before implementing Rails API/backend changes, also read:
- `docs/guidelines/api.md`

Before implementing Next.js/frontend changes, also read:
- `docs/guidelines/frontend.md`

If a task touches both backend and frontend, read both guidelines.
Do not load unrelated guideline files unless the task requires them.

---

## 6. Backend Summary
Rails API is responsible for data integrity and application rules.

Use RESTful routes, strong parameters, meaningful HTTP status codes, model validations, and database constraints.
For detailed API implementation rules, follow `docs/guidelines/api.md`.

---

## 7. Frontend Summary
Next.js is responsible for screens, routing, user experience, and Rails API calls.

Keep UI changes focused, handle loading / error / empty / success states, and avoid unnecessary Client Components.
For detailed frontend implementation rules, follow `docs/guidelines/frontend.md`.

## 8. Working Rules
- Use Plan first for non-trivial tasks.
- Keep changes minimal and focused.
- One task = one focused PR.
- Do not change unrelated files.

## 9. Git Rules
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

## 10. Validation
- Backend: run test/lint before finishing
- Frontend: run lint/build before finishing if frontend exists
- If a validation command cannot be run, explain why in the summary.
- Summarize changed files and why

## 11. Safety
- Do not edit secrets or production config unless explicitly asked.
- Do not change schema, CI, deployment, Docker, or environment files unless the task explicitly requires it.
- If such changes are necessary, explain the reason and impact in the summary.
