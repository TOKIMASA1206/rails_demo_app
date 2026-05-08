---
name: ui-implementation-planner
description: Convert a completed UI image, AI-generated mockup, Paper board, screenshot, or visual concept into an implementation-ready plan. Use when Codex needs to recreate a UI image as editable Paper components, connect those Paper components to Markdown component/API/Issue planning, map each component to APIs or data sources, identify existing-vs-missing implementation work, plan asset extraction with transparent backgrounds, and produce Markdown implementation plans plus parent Issue/sub-Issue breakdowns.
---

# UI Implementation Planner

## Overview

Use this skill to turn a UI image into implementation work. Paper mode recreates the target UI as editable design components; Markdown mode produces the implementation plan. The goal is not pixel-perfect reproduction, but the Paper UI, Markdown component sections, candidate files, and Issues must share the same component names so design and implementation stay connected.

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

When using Paper mode, also include:

```md
## Paper / Implementation Mapping
```

When asked to prepare Issues, output parent Issue and sub-Issue briefs rather than final repository-formatted Issue bodies. Treat the Markdown plan as a design memo and the Issue briefs as the handoff material for a repository-specific Issue workflow. Do not paste the full design memo into GitHub Issues, and do not create GitHub Issues unless the user explicitly asks for GitHub writes.

## Workflow

1. Gather context.
2. Ask the user to choose Paper mode or Markdown-only mode.
3. If Paper mode is chosen, recreate the target UI in Paper as editable components.
4. Decompose the UI into sections and component candidates.
5. Keep Paper component names and Markdown component names aligned.
6. Map components to API/data sources.
7. Compare with the existing implementation.
8. Plan asset extraction.
9. Decide implementation order.
10. Split into parent Issues and sub-Issues at practical reviewable boundaries.
11. Hand off with concise acceptance criteria.

## 1. Gather Context

Collect only what is needed:

- The UI image, screenshot, Paper board, or visual reference.
- Product goal and MVP boundary.
- Target app/framework when known.
- Existing routes/pages/components/API files when available.
- Project guidelines, especially `docs/guidelines/ui-image-to-implementation.md`, frontend guidelines, and API/backend guidelines.

If the user only provides an image, infer a first pass and mark uncertain items as assumptions. Ask questions only when a wrong assumption would materially change the plan.

## 2. Ask User To Choose Tool Mode

Before producing the implementation plan, ask the user whether to use Paper mode or Markdown-only mode, unless the user already made the choice explicitly.

Use a concise question such as:

```text
Paper で編集可能なUI再現まで作りますか？それとも Markdown-only で実装計画だけ作りますか？
```

If the user chooses Paper, use Paper as a planning workbench when available and useful. If the user chooses Markdown-only, produce the plan in Markdown without blocking on Paper. If Paper is unavailable after the user chooses it, explain the connection issue and ask whether to continue in Markdown-only mode.

Paper mode:

- Put the original image on the canvas as a reference.
- Recreate the target UI beside it as editable Paper elements: layout, text, cards, buttons, form fields, status pills, nav items, and repeated rows.
- Name major Paper layers/components with implementation-oriented names such as `AppHeader`, `FilterSidebar`, `ItemCard`, and `CreationPanel`.
- Keep long API/Issue explanations out of Paper; use Paper for the editable UI and short component labels only.
- Use Markdown for detailed component specs, API mapping, existing diff, implementation order, and Issue breakdown.
- Add a `Paper / Implementation Mapping` table in Markdown that links Paper component names to Markdown sections, candidate files, and Issue briefs.
- Do not stop at placing the original image and text notes. The Paper deliverable should be an editable recreation of the UI.

Paper tool-call saving mode:

- Decide component names, card counts, text, colors, and reusable UI structure before writing to Paper.
- Prefer one large write/update over many small node edits.
- Take screenshots sparingly, usually once near the end.
- Batch style or text fixes.
- Do not perform detailed cutouts or background removal in Paper.
- For repeated UI such as cards, rows, filters, and form fields, build one editable example and duplicate it when efficient.

Markdown-only mode:

- Describe sections and components in tables.
- Reference approximate visual locations such as top nav, left panel, hero area, list item, detail modal.
- Continue through API mapping and Issue breakdown without blocking on Paper.

## 3. Decompose UI Sections

Break the image by user-visible purpose, not by visual decoration alone. In Paper mode, use this decomposition to decide what editable UI elements to recreate; in Markdown-only mode, use it to structure the plan.

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

## 4a. Paper Recreation Rules

Use this section only when the user chooses Paper mode.

Paper's main job is to make the target UI editable, not to host long planning notes.

Recreate as editable Paper elements:

- Page shell and layout frames.
- Headers, navigation, sidebars, toolbars, panels.
- Cards, list rows, tables, repeated items.
- Buttons, segmented controls, selects, inputs, textareas, badges, pills.
- Text content and labels.
- Simple icons when they can be recreated with existing icon systems or simple shapes.

Use image assets only for content that should remain imagery:

- Photos and thumbnails.
- Characters, mascots, complex illustrations.
- Textures, patterns, decorative art.
- Unique visuals that are hard or wasteful to recreate with UI elements.

Do not use the original UI image as the implementation surface or page background. Keep it as a reference and build the editable target UI beside it.

Name Paper components/layers intentionally. These names should match Markdown component headings and future implementation names. For example:

```md
Paper layer: ItemCard
Markdown section: ### ItemCard
Candidate file: `src/features/items/components/ItemCard.tsx` or the repository's existing component path
Issue brief: Improve the item card and creation panel UI to match the mockup
```

After recreating the Paper UI, review the screenshot for:

- Whether major UI parts are editable, not flattened images.
- Whether component boundaries are visible through layer names and grouping.
- Whether repeated components can be duplicated or edited independently.
- Whether Paper component names match the Markdown plan.

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

1. Mark cutout targets from the reference image when Paper recreation needs real imagery.
2. Separate editable UI from image assets: build cards/buttons/forms/text in Paper, extract only photos, characters, illustrations, textures, or complex art.
3. Perform cutout, background removal, trimming, compression, and format conversion outside Paper when possible.
4. Save transparent PNG or WebP assets with kebab-case names.
5. Insert the processed asset into the Paper recreation only where the UI truly needs it.
6. Put implementation assets in the framework's static asset location, such as `public/images/...` for Next.js.
7. Add meaningful `alt` text only when the image conveys content; use decorative handling otherwise.
8. Verify desktop/mobile size and non-overlap.

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

## 8a. Paper / Implementation Mapping

When Paper mode is used, the Markdown plan must include a mapping table:

```md
| Paper component | Markdown section | Candidate implementation file | API/data source | Issue brief |
| --- | --- | --- | --- | --- |
| AppHeader | `### AppHeader` | existing or proposed header component path | loaded records for search | Issue brief title |
| FilterSidebar | `### FilterSidebar` | existing or proposed filter component path | category/filter API, loaded records | Issue brief title |
| ItemCard | `### ItemCard` | existing or proposed card component path | item JSON, related lookup data | Issue brief title |
```

Use the same names in:

- Paper layer/component names.
- Markdown component headings.
- Issue brief titles or acceptance criteria.
- Candidate implementation file names.

If a Paper element is decorative or deferred, mark it as deferred in the mapping rather than pretending it has an immediate implementation Issue.

## 9. Issue Breakdown

If a dedicated Issue/PR workflow is available, use this section to create Issue briefs, not final Issue bodies. The repository's Issue workflow and `.github/ISSUE_TEMPLATE/` remain the source of truth for final formatting.

Default to real-world Issue sizing. Use the detailed Markdown plan to think, but compress the handoff into the smallest Issue briefs that let an implementer branch, build, and ask for review without ambiguity.

Use this hierarchy:

- Parent Issue: defines the completed component, screen section, or user workflow.
- Sub-Issue: defines reviewable PR-sized implementation work needed to complete the parent.
- PR: usually maps to one sub-Issue, but small sub-Issues may be grouped.

Parent Issue count:

- Use one parent when the work is one page, one workflow, or one cohesive release goal.
- Split into multiple parents only when completion cannot be described in one sentence, sub-Issues exceed about 8-10, multiple screens are involved, backend/frontend/database work are large and separable, or parts need separate release timing.

Sub-Issue sizing:

- Prefer user value or reviewer value units over work-type units.
- A Sub-Issue should be small enough for one focused branch/PR, but meaningful enough that merging it improves the product or clears a concrete implementation dependency.
- Combine thin work-type tasks such as "API helper", "component split", "state cleanup", and "test coverage" into nearby user-value Issues unless they are substantial enough to review independently.
- Keep separate Sub-Issues when they introduce a reusable foundation, change a broad contract, carry meaningful regression risk, or unblock several later Issues.
- For practice-only workflows, finer-grained Issues may be acceptable. For production-like work, do not split merely to practice GitHub flow.
- If tests are needed, put the relevant test expectation into each Sub-Issue acceptance criteria. Create a separate test Sub-Issue only when test infrastructure is missing or the test work is broad enough to review independently.

Good Sub-Issue shapes:

- `一覧画面をdashboard layoutへ変更する`
- `カテゴリー絞り込みと件数表示を実装する`
- `検索と並び替えを実装する`
- `カードから主要ステータスを更新できるようにする`

Usually too thin by themselves:

- `Component split`
- `State cleanup`
- `API helper`
- `Test coverage`

Parent Issue should include:

- goal
- MVP reason
- UI section/component scope
- API/data source mapping
- assets
- acceptance criteria
- sub-Issue list
- link to the detailed plan, if one exists

Sub-Issue should include:

- one main purpose
- primary guideline to follow
- issue-specific guideline points to apply, not just the guideline file path
- any additional guidelines to reference
- files/areas likely touched
- acceptance criteria as a short checklist
- validation command or review method

Sub-Issues may reference multiple guidelines, but the main responsibility should be clear. For example, a frontend data-connection sub-Issue may mainly follow frontend guidance while also checking API response guidance.

Avoid over-splitting. Use a checklist inside a parent Issue or combine with adjacent work when a task is too small to justify a separate Issue.

When a repository-specific Issue workflow or template skill is available, hand off Issue briefs with stable fields, not final template-shaped bodies. Let the Issue workflow read `.github/ISSUE_TEMPLATE/` and convert these briefs into the repository's actual format.

Parent Issue brief fields:

```md
- Title:
- Goal:
- MVP reason:
- Scope:
- Out of scope:
- Key decisions:
- Detailed plan:
- Suggested sub-Issues:
- Acceptance criteria:
- Notes for Issue workflow:
```

Sub-Issue brief fields:

```md
- Title:
- Parent:
- Goal:
- Scope:
- Out of scope:
- Primary guideline:
- Guideline points for this Issue:
- Likely files/areas:
- Acceptance criteria:
- Validation:
- Notes for Issue workflow:
```

Only use fallback Issue headings directly when no repository Issue template or Issue workflow is available.

## 10. Handoff Checklist

Before handing off the plan or Issues, confirm:

- In Paper mode, the target UI has been recreated as editable Paper elements, not only described with notes.
- In Paper mode, Paper component names match Markdown component headings.
- In Paper mode, the Markdown plan includes `Paper / Implementation Mapping`.
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

Be concise and practical. Lead with the recommended plan, then include tables or Issue briefs. Call out assumptions and blockers clearly. If the user provided an image but not repo access, still produce a useful first-pass plan and list what should be verified in the codebase later.
