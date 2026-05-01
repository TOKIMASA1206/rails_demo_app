---
name: ui-implementation-planner
description: Convert a completed UI image, AI-generated mockup, Paper board, screenshot, or visual concept into an implementation-ready plan. Use when Codex needs to break a UI image into sections/components, map each component to APIs or data sources, identify existing-vs-missing implementation work, plan asset extraction with transparent backgrounds, decide between all-at-once vs staged implementation, and produce Markdown implementation plans plus parent Issue/sub-Issue breakdowns.
---

# UI Implementation Planner

## Overview

Use this skill to turn a UI image into implementation work. The goal is not pixel-perfect reproduction; the goal is to translate the image into components, data/API dependencies, assets, implementation order, and reviewable Issues.

Prefer the repository's own guidance when present. If `docs/guidelines/ui-image-to-implementation.md` exists in the target repo, read it first and let it override this skill where it is more specific. If it does not exist, use this skill as the standalone workflow.

## Output Contract

Unless the user asks for a different artifact, produce a Markdown plan with these sections:

```md
# UI Implementation Plan

## Goal
## MVP Scope
## Out of Scope
## UI Sections
## Components
## API / Data Source Mapping
## Existing Implementation Diff
## Assets
## Implementation Order
## Issue Breakdown
## Open Questions
```

When asked to create Issues, output parent Issue and sub-Issue drafts. Do not create GitHub Issues unless the user explicitly asks for GitHub writes.

## Workflow

1. Gather context.
2. Decide tool mode.
3. Decompose the UI image into sections.
4. Convert sections into component candidates.
5. Map components to API/data sources.
6. Compare with the existing implementation.
7. Plan asset extraction.
8. Decide implementation order.
9. Split into parent Issues and sub-Issues.
10. Hand off with concise acceptance criteria.

## 1. Gather Context

Collect only what is needed:

- The UI image, screenshot, Paper board, or visual reference.
- Product goal and MVP boundary.
- Target app/framework when known.
- Existing routes/pages/components/API files when available.
- Project guidelines, especially `docs/guidelines/ui-image-to-implementation.md`, frontend guidelines, and API/backend guidelines.

If the user only provides an image, infer a first pass and mark uncertain items as assumptions. Ask questions only when a wrong assumption would materially change the plan.

## 2. Decide Tool Mode

Use Paper as a planning workbench when available and useful. Use Markdown-only mode when Paper is unavailable, the task is small, or the user wants minimal tool use.

Paper mode:

- Put the original image on an artboard.
- Add section labels, component labels, and API/data/Issue notes.
- Avoid detailed visual polishing in Paper.
- Use Paper to clarify structure, not to perform implementation.

Paper tool-call saving mode:

- Decide section names, labels, card counts, text, colors, and annotations before writing to Paper.
- Prefer one large write/update over many small node edits.
- Take screenshots sparingly, usually once near the end.
- Batch style or text fixes.
- Do not perform detailed cutouts or background removal in Paper.

Markdown-only mode:

- Describe sections and components in tables.
- Reference approximate visual locations such as top nav, left panel, hero area, list item, detail modal.
- Continue through API mapping and Issue breakdown without blocking on Paper.

## 3. Decompose UI Sections

Break the image by user-visible purpose, not by visual decoration alone.

Common sections:

- page shell
- header/navigation
- hero/summary
- filter/search/sort
- list/grid/table
- card/list item
- detail panel
- form/modal/drawer
- loading/error/empty/success state
- decorative asset/background

For each section, record:

```md
| Section | Role | User action/decision | Needed data | State variants | MVP? |
| --- | --- | --- | --- | --- | --- |
```

## 4. Convert Sections to Components

Create component candidates around meaning and state, not only around visual boxes.

For each component candidate, capture:

```md
### ComponentName
- Role:
- Props/data:
- Local state:
- User actions:
- API/data source:
- Loading/error/empty/success:
- Assets:
- MVP priority:
```

Split a component further when one part owns a different responsibility:

- data fetching
- form input
- filtering/sorting
- mutation
- modal open/close state
- list item/card display
- empty/error state
- asset-only decoration

Avoid premature abstraction. If a component is used once and remains readable, it can stay local to the feature.

## 5. Map API / Data Sources

Before planning implementation, map each component to existing and missing data.

```md
| Component | Needed data/action | Existing API/data source | Missing API/data source | Notes |
| --- | --- | --- | --- | --- |
```

Check:

- Can MVP be built with existing APIs/data sources?
- Is a missing API truly MVP, or can it be deferred?
- Does the API response shape support the component without awkward mapping?
- Are validation, not-found, empty, and error responses displayable?
- Should API/backend work become a separate Issue?

## 6. Compare Existing Implementation

Inspect the target repo enough to avoid planning from the image alone. Prefer fast file discovery (`rg --files`, `rg`) and existing patterns over new structure.

Look for:

- existing pages/routes
- existing components
- API helpers/types/mappers
- state handling patterns
- styling conventions
- asset directories
- tests/lint/build commands
- backend/API gaps

Classify each work item as one of:

- already done
- reuse with small change
- new UI layout
- data connection
- API/backend addition
- asset extraction/integration
- state handling
- responsive polish
- test/validation
- out of scope

## 7. Plan Asset Extraction

Do not turn the whole UI image into a page background. Build UI structure with code and extract only assets that are hard or wasteful to recreate with HTML/CSS.

Asset candidates:

- characters
- complex illustrations
- decorative background pieces
- icon-like artwork that is not available in the icon system
- texture/pattern elements

Preferred flow:

1. Mark cutout targets in Paper or Markdown.
2. Separate code-built UI from image assets.
3. Perform cutout, background removal, trimming, compression, and format conversion outside Paper when possible.
4. Save transparent PNG or WebP assets with kebab-case names.
5. Put assets in the framework's static asset location, such as `public/images/...` for Next.js.
6. Add meaningful `alt` text only when the image conveys content; use decorative handling otherwise.
7. Verify desktop/mobile size and non-overlap.

Use Codex-side tooling or image editing tools for extraction when available. Use Paper only for target selection and placement review to save tool calls.

When the user asks to perform asset work, not just plan it:

- Create or edit only the asset files needed for the selected UI section.
- Prefer transparent PNG for crisp cutouts and WebP for compressed decorative assets.
- Keep original generated images separate from production-ready assets.
- Place final assets in the app's static asset directory.
- Update the relevant component only when the user asks for implementation, not during planning-only tasks.
- Verify the asset renders at expected sizes and does not overlap text or controls.

## 8. Decide Implementation Order

Prefer staged implementation when the image contains multiple components, missing APIs, asset extraction, or unclear states. Implement all at once only for very small, static, low-risk UI changes.

Recommended order:

1. Missing MVP API/data source, if required.
2. Static layout skeleton.
3. Data fetching/connection.
4. Mutations/forms/interactions.
5. Loading/error/empty/success states.
6. Asset integration.
7. Responsive polish.
8. Tests/lint/build/visual checks.

Defer work that is decorative, non-MVP, not backed by data, or risky without a separate design/API decision.

## 9. Issue Breakdown

Use this hierarchy:

- Parent Issue: defines the completed component, screen section, or user workflow.
- Sub-Issue: defines reviewable PR-sized implementation work needed to complete the parent.
- PR: usually maps to one sub-Issue, but small sub-Issues may be grouped.

Parent Issue should include:

- goal
- MVP reason
- UI section/component scope
- API/data source mapping
- assets
- acceptance criteria
- sub-Issue list

Sub-Issue should include:

- one main purpose
- primary guideline to follow
- any additional guidelines to reference
- files/areas likely touched
- acceptance criteria in one sentence
- validation command or review method

Sub-Issues may reference multiple guidelines, but the main responsibility should be clear. For example, a frontend data-connection sub-Issue may mainly follow frontend guidance while also checking API response guidance.

Avoid over-splitting. Use a checklist inside a parent Issue when a task is too small to justify a separate Issue.

## 10. Handoff Checklist

Before handing off the plan or Issues, confirm:

- Each work item has one main purpose.
- MVP vs deferred scope is clear.
- The corresponding UI section is clear.
- Required API/data source is clear.
- Required assets are clear.
- Existing implementation diff is known.
- Acceptance criteria can be stated in one sentence.
- The primary guideline for implementation is clear.
- Multi-guideline sub-Issues still have one main responsibility.

## Final Response Style

Be concise and practical. Lead with the recommended plan, then include tables or Issue drafts. Call out assumptions and blockers clearly. If the user provided an image but not repo access, still produce a useful first-pass plan and list what should be verified in the codebase later.
