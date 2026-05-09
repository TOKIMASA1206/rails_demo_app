---
name: rails-backend-implementation
description: Implement focused Rails API backend changes in a repository. Use when Codex needs to add or refactor Rails routes, controllers, models, validations, database constraints, serializers or JSON responses, API error handling, integration/request/model tests, RuboCop fixes, or Issue-driven backend work that should follow repository API guidelines such as docs/guidelines/api.md and preserve existing Rails API patterns.
---

# Rails Backend Implementation

## Overview

Use this skill to make Rails API changes that are small, reviewable, and production-minded across Rails applications. This skill defines the Rails backend execution workflow; repository-specific decisions come from the nearest `AGENTS.md`, API guidelines, existing code, and the Issue.

## Required Reading

Before editing Rails backend code, read when present:

- `AGENTS.md`
- backend-specific `AGENTS.md` files, such as `backend/AGENTS.md` or `api/AGENTS.md`
- API guidelines such as `docs/guidelines/api.md`
- The Issue body, acceptance criteria, target routes, models, controllers, tests, and nearby implementation patterns
- Gemfile, Rails version, API-only/full-stack setup, test framework, serializer conventions, and development commands when they affect the change

Treat repository API guidelines as the primary backend best-practice baseline when they exist. Use this skill to execute that guidance consistently, not to replace it.

If the task also changes frontend behavior, read the repository's frontend guidelines and keep frontend work in a separate Issue unless the user explicitly scopes both.

For full-stack Rails apps, apply this skill only to API/backend-facing changes and preserve existing HTML/view behavior unless the Issue explicitly includes it.

## Working Contract

- Keep one Issue focused on one main backend goal: endpoint, model rule, validation, database constraint, response shape, error handling, or test coverage.
- Prefer the repository's existing Rails, routing, controller, model, migration, fixture/factory, serializer, response, error, and test patterns.
- Treat this skill as a Rails backend execution workflow. If it conflicts with repository instructions, follow the nearest `AGENTS.md`, API guidelines, Issue requirements, and existing code.
- Use RESTful routes, strong parameters, meaningful HTTP status codes, model validations, and database constraints.
- Keep controllers thin: receive params, load or persist models, call small scopes/query objects/services when justified, and render JSON.
- Put data integrity, authorization-sensitive checks, and application rules in Rails, not in the frontend.
- Do not add features, endpoints, tables, background jobs, authentication flows, authorization rules, external integrations, dependencies, or broad abstractions unless they are explicitly requested in the Issue, acceptance criteria, or existing product scope.
- Avoid unrelated schema, config, CI, deployment, dependency, or environment changes.
- Add the minimum useful abstraction only when it reduces real duplication or clarifies ownership.
- Match the app's maturity: keep small apps simple, but preserve production fundamentals for security, data integrity, observability, and maintainability.

## Workflow

1. Orient to the Issue.
   - Infer the user goal, acceptance criteria, target resource, affected files, and validation commands from the Issue, docs, and existing code.
   - Ask for clarification only when implementation would be unsafe or ambiguous in a way that cannot be resolved from the repository.
   - Run `git status --short --branch`.
   - Inspect existing routes, controllers, models, migrations, tests, and scripts with `rg --files` and `rg`.
   - Check the current API response and error conventions before introducing new shapes.

2. Design the API surface.
   - Model the API around resources and standard HTTP methods.
   - Use `namespace :api` and `resources` when they match local routing patterns.
   - Use query params for filtering and sorting before adding custom routes.
   - Avoid verb-heavy URLs such as `create_spot` or `delete_spot`.
   - Keep nesting shallow, usually one or two levels.
   - Use versioning for new API designs when the repository already uses it; do not migrate existing APIs as a side effect.
   - Preserve backward compatibility unless the Issue explicitly permits a breaking API change.

3. Plan the data and rule changes.
   - Check associations, validations, scopes, enums/constants, defaults, nullability, indexes, and foreign keys.
   - Use model validation for user-facing errors and database constraints for data integrity.
   - Add migrations only when the Issue requires schema changes.
   - Keep migrations small, reversible where practical, and explicit about defaults and existing data impact.
   - When migrations change, ensure `db/schema.rb` or `db/structure.sql` is updated according to the repository convention.
   - Add indexes only for clear lookup paths or measured need; avoid speculative indexing.
   - Use transactions when one request must change multiple records atomically.

4. Implement in a narrow pass.
   - Define or update routes first, then controller actions, model rules, response helpers, and tests.
   - Use strong parameters and never use `permit!`.
   - Prefer `find`/`find_by!` plus existing exception handling when the app already standardizes 404 behavior.
   - Keep business logic out of controllers; use model methods or scopes first, then query objects/services only when complexity justifies them.
   - Avoid mass-assignment of trusted fields such as ownership, role, tenant, price, status transitions, or audit fields unless the Issue and domain rules explicitly allow it.
   - Check common performance traps such as N+1 queries on list/show endpoints and use the repository's established eager-loading pattern when needed.
   - Do not leave debug logs, unused methods, placeholder branches, or broad TODOs.

5. Shape JSON responses deliberately.
   - Return only fields the frontend needs; avoid leaking internal or sensitive data.
   - Keep response names and nesting consistent with nearby endpoints.
   - For `create`, return `201 Created` with the created resource unless local convention differs.
   - For `update`, return `200 OK` with the updated resource or the existing local convention.
   - For `destroy`, return `204 No Content` unless the app already returns a body.
   - For validation failures, prefer `422 Unprocessable Entity` and an error shape usable by frontend forms, such as `{ message: "...", errors: { field: ["..."] } }`.
   - Keep `401`, `403`, `404`, `422`, and `500` meanings distinct.

6. Keep frontend usability in view.
   - Confirm list endpoints return stable IDs and fields needed for rendering.
   - Confirm forms can map validation errors back to fields.
   - Confirm empty lists, missing records, invalid params, and validation errors are predictable.
   - Prefer simple explicit JSON for small APIs; introduce serializers only when response duplication or complexity is real.
   - Preserve existing pagination, sorting, filtering, and envelope conventions; add pagination metadata only when the endpoint size or product need justifies it.

7. Add or update tests.
   - Use model tests for validations, associations, scopes, and domain methods.
   - Use integration/request tests for endpoint status codes, response body, params, filtering, persistence, and failure paths.
   - Test success and meaningful failure cases: invalid params, missing records, invalid foreign keys, and filters when relevant.
   - If database constraints change, ensure tests run after migration state is current.
   - Keep fixtures/factories aligned with required validations and constraints.
   - Follow the repository's test framework and naming conventions instead of introducing a new test stack.

8. Validate.
   - Prefer the repository's documented validation commands from `AGENTS.md`, README, bin scripts, Makefile, Docker Compose setup, or CI.
   - If none are documented, infer the safest Rails commands:
     - `bin/rails test` or `bundle exec rails test` for Minitest projects
     - `bundle exec rspec` for RSpec projects
     - `bin/rubocop` or `bundle exec rubocop` for Ruby style checks
   - Use `docker compose exec <service> ...` only when the repository uses Docker for development.
   - Run targeted tests first when useful, then the full backend test command before finishing.
   - If routes changed, inspect route output or add/request tests that prove the route exists.
   - If a command cannot run, capture the exact command, error, and likely reason in the final summary.

9. Hand off clearly.
   - Summarize changed files and why.
   - Mention validation commands and results.
   - If validation was skipped or partially run, explicitly list what was not run and why.
   - Call out schema changes, response shape changes, intentional deferrals, test gaps, or follow-up Issues.

## Review Checklist

Before final response, check:

- Does the change satisfy only this Issue's scope?
- Are routes resource-oriented and HTTP methods appropriate?
- Are controllers thin and protected by strong parameters?
- Are model validations and database constraints both considered for required data integrity?
- Are status codes, success responses, and error responses consistent with existing APIs?
- Can the frontend display field-level validation errors without special parsing?
- Are trusted fields protected from unsafe params?
- Are obvious N+1 queries, missing transactions, and accidental breaking response changes considered?
- Are success and failure paths covered by tests proportional to the risk?
- Did RuboCop and Rails tests run, or is the reason they could not run clearly captured?
