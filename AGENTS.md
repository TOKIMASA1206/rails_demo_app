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

## 5. API Design Principles
Use RESTful Rails routes.

Preferred route style:
- GET /api/spots
- GET /api/spots/:id
- POST /api/spots
- PATCH /api/spots/:id
- DELETE /api/spots/:id

Filtering should prefer query params when possible, for example:
- GET /api/spots?category_id=1

General API rules:
- use `namespace :api`
- use `resources`
- use strong parameters
- return meaningful HTTP status codes
- keep controllers thin
- avoid custom non-RESTful routes unless clearly justified

---

## 6. Validation and DB Rules
Always think at both levels:
- application-level validation
- database-level constraints

### Required validations
Category:
- name: presence

Spot:
- name: presence
- status: presence
- category: presence

### Preferred DB constraints
Use constraints in migrations where appropriate:
- `null: false` for required fields
- `default:` for natural defaults
- foreign keys for associations

Example principles:
- `status` should default to `want_to_go`
- `category_id` should be required
- avoid relying only on model validation

---

## 7. Controller Rules
Controllers should stay thin.

Controllers should mainly:
- receive request params
- call model/query logic
- render JSON
- return correct status codes

Avoid putting large business logic directly in controllers.

Use strong params in private methods, for example:

```rb
def spot_params
  params.require(:spot).permit(:category_id, :name, :note, :url, :status, :visited_on)
end
```
Do not use `permit!`.

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
- Frontend: run lint/typecheck before finishing if frontend exists
- Summarize changed files and why

## Safety
- Do not edit secrets or production config unless explicitly asked.
- Ask before changing schema, CI, or deployment files.