# SpotLog MVP Top Page UI Implementation Plan

## Goal

SpotLog のトップページを、MVP の主要導線である「スポット作成」「スポット一覧」「カテゴリー絞り込み」「ステータス確認/更新」が 1 画面で扱える dashboard UI に整理する。

## MVP Scope

- ヘッダーに SpotLog logo、検索入力、ユーザー領域を配置する。
- 左サイドバーでカテゴリー別にスポットを絞り込めるようにする。
- 中央にスポット一覧を 2 column card grid で表示する。
- 右側に新規スポット追加フォームを固定幅 panel として配置する。
- 既存 MVP の `want_to_go` / `visited` を status pill と segmented control で表現する。
- loading / error / empty / success の状態を dashboard layout 内で破綻なく表示する。

## Out of Scope

- 認証 UI / 認可フロー
- Google Maps / 地図表示
- 画像アップロード、thumbnail 表示
- rating、comment、favorite、public sharing
- category 管理 UI の本実装
- 高度な検索、全文検索、複合条件 filter
- 通知、analytics、recommendation

## UI Sections

| Section | Role | User action/decision | Needed data | State variants | MVP? |
| --- | --- | --- | --- | --- | --- |
| Page shell | Header / sidebar / list / form の全体配置 | 画面全体を見て操作場所を把握する | spots, categories | loading, error, empty, success | yes |
| Header | App identity と検索入口 | キーワードを入力する | loaded spots or query state | default, searching | yes |
| Category sidebar | カテゴリー絞り込みと件数確認 | category を選ぶ | categories, spots count per category | selected, empty categories, category fetch error | yes |
| Spot list toolbar | 一覧件数と並び順を操作 | sort を選ぶ、view mode を確認する | selected category, filtered spots, sort | default, no result | yes |
| Spot grid | filtered spots を一覧する | spot を見る、URL を開く、詳細操作へ進む | spots, categories | loading, error, empty, success | yes |
| Spot card | 1 件の spot の概要を読む | status を確認する、URL を開く、menu を開く | spot, category name | want_to_go, visited | yes |
| Add spot panel | 新しい spot を作成する | name/category/status/note/url を入力して保存 | categories, form values | idle, submitting, validation error, success | yes |

## Components

### SpotsPageShell

- Role: dashboard 全体の layout と data/state の受け渡しを管理する。
- Props/data: spots, categories, selectedCategoryId, searchQuery, sort.
- Local state: selectedCategoryId, searchQuery, sort, optimistic created spot if client-side.
- User actions: category select, search input, sort select, create spot, possibly status update.
- API/data source: `GET /api/spots`, `GET /api/categories`, `POST /api/spots`, later `PATCH /api/spots/:id`.
- Loading/error/empty/success: page level status.
- MVP priority: high.

### SpotLogHeader

- Role: brand, search input, top-level controls.
- Props/data: searchQuery, onSearchChange.
- Local state: none or controlled input only.
- User actions: spot search.
- API/data source: initially client-side filtering over loaded spots.
- Loading/error/empty/success: no dedicated state.
- MVP priority: medium.

### CategorySidebar

- Role: category filter and category counts.
- Props/data: categories, spots, selectedCategoryId.
- Local state: none if controlled by parent.
- User actions: select all or one category.
- API/data source: `GET /api/categories`, loaded spots for counts.
- Loading/error/empty/success: categories loading/error can be surfaced in sidebar area.
- MVP priority: high.

### SpotListToolbar

- Role: list title, filtered count, sort control, view toggle display.
- Props/data: filtered count, sort.
- Local state: none if controlled by parent.
- User actions: change sort.
- API/data source: existing `GET /api/spots?sort=created_at_desc`; `name_asc` also exists.
- Loading/error/empty/success: no dedicated state.
- MVP priority: medium.

### SpotGrid

- Role: render a responsive list/grid of SpotCard.
- Props/data: filtered/sorted spots, categories.
- Local state: none.
- User actions: none directly beyond child actions.
- API/data source: loaded spots.
- Loading/error/empty/success: empty state when no spots or no filter results.
- MVP priority: high.

### SpotCard

- Role: display one spot with category, note, url, date, status.
- Props/data: spot, categoryName.
- Local state: optional pending state if status update is implemented on card.
- User actions: open URL, menu, later status update.
- API/data source: spot JSON, category lookup, later `PATCH /api/spots/:id`.
- Loading/error/empty/success: status update pending/error if implemented.
- MVP priority: high.

### AddSpotPanel

- Role: create spot form in the right panel.
- Props/data: categories, onCreated.
- Local state: form values, submit state, error.
- User actions: input fields, choose category, choose status, submit.
- API/data source: `POST /api/spots` with `X-User-Id`.
- Loading/error/empty/success: submitting, validation error, category error, success reset.
- MVP priority: high.

### StatusSegmentedControl

- Role: status selection for create form and optionally card-level update.
- Props/data: value, onChange, disabled.
- Local state: none if controlled.
- User actions: choose `want_to_go` or `visited`.
- API/data source: none directly; parent form/card mutation.
- Loading/error/empty/success: disabled/pending.
- MVP priority: high for form, medium for card update.

## API / Data Source Mapping

| Component | Needed data/action | Existing API/data source | Missing API/data source | Notes |
| --- | --- | --- | --- | --- |
| SpotsPageShell | fetch spots/categories | `GET /api/spots`, `GET /api/categories` | API helper organization | Existing UI fetches in `useEffect`; guideline prefers avoiding `useEffect` for initial display when feasible. |
| CategorySidebar | categories and counts | `GET /api/categories`, loaded spots | none | Counts can be computed client-side for MVP. |
| SpotListToolbar | sort | `GET /api/spots?sort=created_at_desc`, `name_asc` | none | UI label maps to existing sort values. |
| SpotLogHeader | search | loaded spots | none for MVP | Client-side search is enough; advanced search is out of scope. |
| SpotGrid / SpotCard | spot list and category name | `GET /api/spots`, category lookup | none | Thumbnail is intentionally not included. |
| AddSpotPanel | create spot | `POST /api/spots` | none | Existing form already creates spots. |
| StatusSegmentedControl on card | update status | `PATCH /api/spots/:id` with `X-User-Id` | frontend helper/action | Backend route exists; update requires the same demo user header as create because the API authenticates and authorizes the spot owner. |

## Existing Implementation Diff

- `frontend/src/app/page.tsx` currently renders a simple centered page with `SpotLog` heading and `SpotsList`.
- `frontend/src/app/components/SpotsList.tsx` currently combines fetch state, category fetch, list rendering, item rendering, and created spot insertion in one Client Component.
- `frontend/src/app/components/SpotCreateForm.tsx` already handles create form state, submit state, error display, `POST /api/spots`, and demo user header.
- `frontend/src/types/spot.ts` and `frontend/src/types/category.ts` already provide base shared types.
- Existing frontend has no `src/features/spots/` structure, API helper, dashboard shell, category filter state, search state, or status update UI.
- Existing backend already supports category filtering, sort, create, update, and delete routes needed for this MVP top page.

## Assets

No production image assets are needed for this UI.

- The generated UI has no thumbnails.
- Simple category icons should be implemented with the existing icon approach or lightweight inline/lucide icons if the project adds an icon library later.
- Do not use the generated screenshot as a background.

## Paper / Implementation Mapping

| Paper component | Markdown section | Candidate implementation file | API/data source | Issue brief |
| --- | --- | --- | --- | --- |
| SpotLogTopPageShell | `### SpotsPageShell` | `frontend/src/features/spots/components/SpotsPageShell.tsx` | spots, categories, local filter/sort/search state | Spot一覧画面をdashboard layoutへ変更する |
| SpotLogHeader | `### SpotLogHeader` | `frontend/src/features/spots/components/SpotLogHeader.tsx` | loaded spots for client-side search | 検索と並び替えを実装する |
| CategorySidebar | `### CategorySidebar` | `frontend/src/features/spots/components/CategorySidebar.tsx` | `GET /api/categories`, loaded spots | カテゴリー絞り込みと件数表示を実装する |
| SpotListToolbar | `### SpotListToolbar` | `frontend/src/features/spots/components/SpotListToolbar.tsx` | selected filters, sort state | 検索と並び替えを実装する |
| SpotGrid | `### SpotGrid` | `frontend/src/features/spots/components/SpotGrid.tsx` | filtered/sorted spots | Spot一覧画面をdashboard layoutへ変更する |
| SpotCard | `### SpotCard` | `frontend/src/features/spots/components/SpotCard.tsx` | spot JSON, category lookup, optional `PATCH /api/spots/:id` | SpotCardから訪問ステータスを更新できるようにする |
| AddSpotPanel | `### AddSpotPanel` | `frontend/src/features/spots/components/AddSpotPanel.tsx` | `POST /api/spots`, categories | SpotCardとAddSpotPanelのUIを整理する |
| StatusSegmentedControl | `### StatusSegmentedControl` | `frontend/src/features/spots/components/StatusSegmentedControl.tsx` | form value or status update mutation | SpotCardとAddSpotPanelのUIを整理する |
| SaveSpotButton | local child of AddSpotPanel | local component or inline button | create mutation state | SpotCardとAddSpotPanelのUIを整理する |

## Implementation Order

1. Create a small feature structure and API helper for spots/categories/create/update calls.
2. Move the current page toward `SpotsPageShell` dashboard layout without changing behavior.
3. Implement `CategorySidebar` filter and category counts.
4. Implement client-side search and sort UI, backed by existing sort/query choices where useful.
5. Polish `SpotCard`, `SpotGrid`, `AddSpotPanel`, and `StatusSegmentedControl` to match the Paper recreation.
6. Add card-level status update using existing `PATCH /api/spots/:id` if included in this parent scope.
7. Add focused tests or verification for filter/search/create/status states according to available test setup.

## Issue Breakdown

### Parent Issue brief

- Title: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: スポット一覧、カテゴリー絞り込み、新規作成、ステータス確認/更新を 1 画面で扱えるトップページにする。
- MVP reason: SpotLog の主要操作を最短導線で試せるようにし、MVP を実際のアプリらしい画面構成に近づけるため。
- Scope: header, category sidebar, spot list toolbar, spot grid/card, add spot panel, basic search/sort/status UI.
- Out of scope: auth, map, thumbnails, image upload, ratings/comments, advanced search, category management UI.
- Key decisions: thumbnails are deferred; search is client-side for MVP; category counts are computed from loaded spots; generated image is not used as an implementation asset.
- Detailed plan: `docs/plans/spotlog-mvp-top-page-implementation-plan.md`
- Suggested sub-Issues:
  - Spot一覧画面の feature 構成と API helper を整理する
  - Spot一覧画面を dashboard layout へ変更する
  - カテゴリー絞り込みと件数表示を実装する
  - 検索と並び替えを実装する
  - SpotCard と AddSpotPanel の UI を整理する
  - SpotCard から訪問ステータスを更新できるようにする
- Acceptance criteria:
  - spot を追加でき、一覧に反映される。
  - category で一覧が絞り込まれ、件数が表示と一致する。
  - search/sort が MVP の範囲で動作する。
  - status が UI 上で判別でき、対象範囲に含める場合は card から更新できる。
  - loading / error / empty / success が dashboard layout 内で破綻しない。
  - desktop/mobile で text/button が重ならない。
- Notes for Issue workflow: repo の `.github/ISSUE_TEMPLATE/task.md` に沿って GitHub Issue 化する。

### Sub-Issue brief 1

- Title: Spot一覧画面の feature 構成と API helper を整理する
- Parent: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: dashboard UI 実装前に、spots 関連の API 呼び出しと component 配置を追いやすくする。
- Scope: `src/features/spots/` の導入、spots/categories/create/update の薄い API helper、既存型の配置判断。
- Out of scope: 大きな UI 変更、filter/search/status UI の実装。
- Primary guideline: `docs/guidelines/frontend.md`
- Guideline points for this Issue: API base URL / JSON fetch / HTTP error handling を helper に寄せる。Server/Client の境界を壊さない。過剰な汎用 client を作らない。
- Likely files/areas: `frontend/src/features/spots/api/`, `frontend/src/features/spots/types.ts`, existing `frontend/src/types/*`.
- Acceptance criteria: 既存の一覧取得と作成処理が壊れず、後続 Issue が API 呼び出しを component から切り離して使える。
- Validation: `docker compose exec frontend npm run lint`
- Notes for Issue workflow: 既存 #61 と重なる可能性がある。

### Sub-Issue brief 2

- Title: Spot一覧画面を dashboard layout へ変更する
- Parent: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: 既存トップページを header / sidebar / list / add panel の基本レイアウトへ変更する。
- Scope: `SpotsPageShell`, `SpotLogHeader`, `SpotGrid`, layout responsive base, existing create/list behavior preservation.
- Out of scope: filter/search/sort/status update の本格挙動。
- Primary guideline: `docs/guidelines/frontend.md`
- Guideline points for this Issue: 1 Issue の主目的を layout に絞る。既存の一覧表示・作成処理を壊さない。mobile で text/button が崩れないことを確認する。
- Likely files/areas: `frontend/src/app/page.tsx`, `frontend/src/features/spots/components/*`, existing `SpotsList.tsx`, `SpotCreateForm.tsx`.
- Acceptance criteria: Paper の大枠に近い dashboard layout で、既存の spot 一覧と作成が使える。
- Validation: `docker compose exec frontend npm run lint`, layout 変更が大きければ `docker compose exec frontend npm run build`
- Notes for Issue workflow: 既存 #71 と置き換え候補。

### Sub-Issue brief 3

- Title: カテゴリー絞り込みと件数表示を実装する
- Parent: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: sidebar の category 選択で一覧を絞り込み、各 category の件数を表示する。
- Scope: `CategorySidebar`, selectedCategory state, all/category counts, no-result empty state.
- Out of scope: category create/update/delete UI.
- Primary guideline: `docs/guidelines/frontend.md`
- Guideline points for this Issue: loading / error / empty を扱う。API query にするか client-side にするかを Issue 内で明示する。MVP では既存 API と loaded spots を優先する。
- Likely files/areas: `CategorySidebar.tsx`, `SpotsPageShell.tsx`, spot filtering helper.
- Acceptance criteria: category を選ぶと一覧と件数が一致し、該当 0 件時の empty state が表示される。
- Validation: `docker compose exec frontend npm run lint`
- Notes for Issue workflow: backend API は既に `category_id` filter を持つが、MVP では client-side でも可。

### Sub-Issue brief 4

- Title: 検索と並び替えを実装する
- Parent: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: header search と toolbar sort により、一覧を探しやすくする。
- Scope: searchQuery state, spot name/note/category search, sort select, filtered count.
- Out of scope: advanced search, backend full-text search.
- Primary guideline: `docs/guidelines/frontend.md`
- Guideline points for this Issue: advanced search を追加しない。既存 `sort` API を使うか client-side sort にするかを明示する。検索結果 0 件の empty state を扱う。
- Likely files/areas: `SpotLogHeader.tsx`, `SpotListToolbar.tsx`, `SpotsPageShell.tsx`.
- Acceptance criteria: 検索語と並び順が一覧に反映され、件数表示が現在の表示内容と一致する。
- Validation: `docker compose exec frontend npm run lint`
- Notes for Issue workflow: search は MVP 上 client-side で十分。

### Sub-Issue brief 5

- Title: SpotCard と AddSpotPanel の UI を整理する
- Parent: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: Paper のカード/フォーム見た目に合わせ、MVP 操作を読みやすくする。
- Scope: card typography/status pill/date/url/more button visual, right-side add panel, segmented status control, submit/error states.
- Out of scope: card-level status update mutation.
- Primary guideline: `docs/guidelines/frontend.md`
- Guideline points for this Issue: 入力欄には label を付ける。button disabled/submitting/error 表示を残す。既存 create behavior を壊さない。
- Likely files/areas: `SpotCard.tsx`, `AddSpotPanel.tsx`, `StatusSegmentedControl.tsx`, create form logic.
- Acceptance criteria: Paper の UI に近い card/form で spot を作成でき、validation/error/submitting 表示が破綻しない。
- Validation: `docker compose exec frontend npm run lint`
- Notes for Issue workflow: 既存 `SpotCreateForm` の責務を移す場合は差分を小さく保つ。

### Sub-Issue brief 6

- Title: SpotCard から訪問ステータスを更新できるようにする
- Parent: SpotLog のトップページを MVP dashboard UI へ整理する
- Goal: 一覧上で `行きたい` / `訪問済み` を更新できるようにする。
- Scope: card action UI, `PATCH /api/spots/:id`, pending/error handling, local state update.
- Out of scope: bulk update, history, visited_on の高度な入力 UI.
- Primary guideline: `docs/guidelines/frontend.md`
- Additional guideline: `docs/guidelines/api.md` を API response/error handling の確認に参照。
- Guideline points for this Issue: DB 更新の最終判断は Rails API に置く。`PATCH /api/spots/:id` では create と同じく `X-User-Id` を送る。二重送信を防ぐ。失敗時に UI を戻すか再取得する方針を明示する。
- Likely files/areas: `SpotCard.tsx`, spots API helper, `SpotsPageShell.tsx`.
- Acceptance criteria: card から status を更新でき、成功時に UI が変わり、失敗時にエラーを確認できる。
- Validation: `docker compose exec frontend npm run lint`
- Notes for Issue workflow: 必須 MVP とするか後続に回すかは Issue 作成前に決める。

## Open Questions

- Initial data fetching を Server Component 化するか、既存 Client Component を維持して段階的に進めるか。
- `src/features/spots/` へ移すタイミングを最初の Sub-Issue に含めるか、layout 変更と同時に行うか。
- category filter / sort は API query に寄せるか、MVP では loaded spots の client-side 処理にするか。
- card-level status update をこの Parent Issue に含めるか、後続 Issue として切り出すか。
- component test 基盤が未整備の場合、どの Sub-Issue で最低限のテストを始めるか。
