# UI Image to Implementation Planning Guidelines

本格的な個人開発では、生成 AI などで作った完成形 UI 画像をそのまま一気に実装しない。
画像を Paper 上で画面構造に分解し、意味のある単位で component、API、素材、Issue に整理してから実装する。

## Purpose

このガイドラインは、UI 画像から実装計画を作る前に確認する判断基準として使う。
見た目の再現だけを急がず、プロダクトの MVP に必要な画面・データ・API・作業単位へ落とし込むための流れをまとめる。

## 基本方針

- UI 画像は完成仕様ではなく、見た目・雰囲気・構成の参考として扱う。
- まず Paper で画面を区画化し、意味のある単位で component 候補を整理する。
- Paper は作り込みすぎず、区画分解、注釈、構成確認、素材整理に使う。
- 実装計画は Markdown にまとめ、Issue 分割できる状態にする。
- 既存 API と未実装 API を整理し、UI component がどの API や data source と対応するか明確にする。
- MVP に不要な装飾、状態、API、画面遷移は別 Issue に送る。
- 1 Issue では、ひとつの component、API、状態、または表示改善に目的を絞る。

## Recommended Workflow

1. 外部で UI 完成画像を作成する。
2. 完成画像を Paper に取り込む。
3. Paper 上で画面を区画に分ける。
4. 区画ごとに役割、必要データ、操作、状態を注釈する。
5. 区画を意味のある component 候補に整理する。
6. 画像内素材が必要な場合は、切り抜き対象を決める。
7. 既存 UI / API / data source と比較し、実装済みと未実装を分ける。
8. UI component と API endpoint / data source の対応表を作る。
9. MVP 優先度を決め、Markdown で実装計画を作る。
10. 親 Issue / sub Issue に分割する。

## Paper Usage

Paper は、生成画像を実装可能な設計に翻訳する作業台として使う。
Figma のような長期的な design system 管理ではなく、個人開発で素早く構成を固める用途を優先する。

Paper 上では、次の情報を整理する。

- 画面全体の構成
- header、filter、list、card、form、modal、empty state などの区画
- 各区画の責務
- component 候補
- 必要なデータ
- 必要な API / data source
- 実装済み部分と未実装部分
- 切り抜いて使う画像素材
- MVP に入れるものと後回しにするもの

## Paper Tool Call Saving Mode

Paper Free プランでは MCP tool call 数を節約するため、細かい往復を減らす。
原則は「事前に決めて、一括で作り、最後に確認する」。

- Paper に書き込む前に、画面区画、文言、カード数、色、余白、注釈内容を Markdown で固める。
- `write_html` などの一括書き込みを優先し、小さな node 作成を何度も繰り返さない。
- screenshot 確認は最後の 1 回を基本にする。
- 微修正は個別に依頼せず、余白、サイズ、文言、色をまとめて 1 回で修正する。
- 既存 node 調査は必要最小限にする。
- Paper 上で pixel perfect を目指さず、最終調整は実装側で行う。
- 繰り返し要素は、1 個ずつ作るより一括で生成する。
- call 数を節約したい作業では、途中確認よりも実装計画の精度を優先する。

Paper で最低限作るものは、次の 4 つに絞る。

- UI 画像を置いた artboard
- 区画ごとの枠線またはラベル
- component 候補名
- API / data / Issue 分割の注釈

## UI Section Breakdown

UI 画像を見たら、まず見た目ではなく役割で区画に分ける。

区画の例:

- page shell
- header
- navigation
- filter / search
- list
- card
- detail panel
- form
- modal
- loading state
- error state
- empty state
- decorative asset

各区画について、次を確認する。

- その区画は何をする場所か。
- ユーザーはそこで何を判断、入力、操作するか。
- 表示に必要なデータは何か。
- API、database、CMS、local state、固定値のどこから来るデータか。
- loading / error / empty / success が必要か。
- responsive 時にどう並び替えるか。
- MVP に必要か、後回しでよいか。

## Component Breakdown

component は見た目のまとまりだけで分けない。
ユーザーにとっての意味、必要データ、操作、状態がまとまっている単位で分ける。

component 候補ごとに、次を整理する。

```md
## Component
- name:
- role:
- props:
- state:
- user actions:
- API / data source:
- loading / error / empty:
- MVP priority:
```

component が大きすぎる場合は、次の境界で分ける。

- data fetching
- form input
- filter state
- list item / card display
- modal open / close
- API mutation
- loading / error / empty display
- decorative asset display

## API Mapping

UI component を整理したら、既存 API と未実装 API を分ける。
実装に入る前に、component がどの endpoint や data source に依存するかを表にする。

```md
| Component | Needed data/action | Existing API/data source | Missing API/data source | Notes |
| --- | --- | --- | --- | --- |
| ItemList | item list | GET /api/items | - | filter needed |
| ItemCreateForm | create item | POST /api/items | - | validation error display |
| CategoryFilter | category list | GET /api/categories | - | empty category handling |
```

確認すること:

- 既存 API / data source だけで MVP 画面を作れるか。
- 足りない API は本当に MVP に必要か。
- API が足りない場合、UI Issue に混ぜず API / backend Issue として分けるか。
- API response の形は component が扱いやすいか。
- validation error、not found、empty response を UI で表示できるか。

## Existing Implementation Diff

Paper で component 候補を作った後、既存実装との差分を見る。
画像の理想形から考えるだけでなく、現在の codebase に何があるかを基準に作業単位を切る。

確認すること:

- 既存 page / route はあるか。
- 既存 component を流用できるか。
- 既存 API helper / type / mapper はあるか。
- 既存 CSS / Tailwind のトーンに合わせられるか。
- 追加する状態は loading / error / empty / success のどれか。
- schema や API 変更が必要か。
- UI だけで完結するか、API / backend Issue が必要か。

作業単位は、次のどれかに分ける。

- static layout
- data fetching
- form / mutation
- filter / search
- loading / error / empty states
- responsive adjustment
- asset integration
- API addition
- test / lint / build

## Asset Extraction

画像内のキャラクターや装飾素材を使う場合は、UI 全体を画像として貼らない。
必要な素材だけを切り抜き、透明背景化し、実装で扱える asset として組み込む。

Paper は素材加工の場所ではなく、どの素材が必要かを判断する場所として使う。
切り抜き、背景除去、圧縮、形式変換は、可能なら Codex 側または画像編集ツール側で行い、完成した asset だけを Paper と実装に渡す。

推奨手順:

1. Paper 上で切り抜き対象を決める。
2. UI としてコードで再現すべき部分と、画像素材として使う部分を分ける。
3. Paper 上では素材範囲にラベルを付けるだけにし、細かい切り抜き操作を繰り返さない。
4. 元画像を Codex 側に渡し、キャラクター、背景装飾、アイコン風素材などを個別に切り出す。
5. 透明背景の PNG または WebP にする。
6. 必要なら余白を trim し、実装で扱いやすいサイズに圧縮する。
7. ファイル名は役割が分かる kebab-case にする。
8. 完成 asset だけを Paper に戻し、配置イメージを確認する。
9. 使用する framework の静的 asset 置き場に配置する。Next.js なら `public` 配下に置く。
10. framework の image component、または通常の `img` で表示する。
11. `alt` が必要な意味のある画像か、装飾画像かを判断する。
12. mobile / desktop で表示サイズが崩れないか確認する。

配置例:

```text
public/images/items/item-card-mascot.png
public/images/decorations/map-pin-pattern.webp
```

判断基準:

- ボタン、カード、余白、テキストは画像化せず HTML / CSS で作る。
- キャラクターや複雑な装飾だけ画像素材として扱う。
- 画像がなくても主要操作が成立するようにする。
- Paper の tool call を消費して細かい切り抜きを繰り返すより、Codex 側で asset を作ってから Paper に戻す。
- Paper には元画像、切り抜き対象ラベル、完成 asset の配置確認だけを置く。
- 素材追加だけの Issue と UI 実装 Issue は、必要に応じて分ける。

## Markdown Implementation Plan

Paper で整理した内容は、最終的に Markdown の実装計画に落とす。
Issue を作る前に、次の形でまとめる。

```md
# UI Implementation Plan

## Goal

## MVP Scope

## Out of Scope

## Components

## API Mapping

## Existing Implementation Diff

## Implementation Order

## Assets

## Issue Breakdown
```

実装順は、ユーザーが触れる主要導線から決める。

1. API が足りない場合は、最小 API を先に作る。
2. 静的 layout で画面の骨格を作る。
3. 既存 API から data fetching する。
4. 作成、更新、削除などの mutation を追加する。
5. loading / error / empty / success を整える。
6. responsive と細かい見た目を調整する。
7. 画像素材を必要最小限で組み込む。

## Issue Breakdown

Issue は component ごとに親 Issue を作る。
その component を完成させるための作業が Issue 規模になる場合は sub Issue に分ける。

親 Issue には次を書く。

- component の目的
- MVP に含める理由
- 対応する Paper の区画
- 対応する API
- 完了条件
- sub Issue 一覧

sub Issue に分ける例:

- static layout
- API helper / type
- data fetching
- create / update / delete
- validation error display
- loading / error / empty states
- responsive
- asset integration
- tests

分けすぎを避けるため、次の基準を使う。

- 1 PR でレビューしやすいか。
- UI と API / backend の変更が混ざりすぎていないか。
- schema 変更、API 追加、UI 実装が同じ Issue に詰まっていないか。
- MVP に不要な見た目調整だけで Issue が増えていないか。
- sub Issue なしで済む小さい component では、親 Issue だけにする。

## Issue Handoff Checklist

Issue に分ける前に、各作業単位について次を確認する。

- 目的が 1 つに絞られているか。
- MVP に含める理由が説明できるか。
- 対応する UI 区画が明確か。
- 必要な API / data source が明確か。
- 必要な asset が明確か。
- 既存実装との差分が分かっているか。
- 完了条件を 1 文で説明できるか。
- 実装時に従う guideline が分かっているか。

親 Issue は component 全体を扱うため、UI、API、asset など複数の guideline にまたがってよい。
sub Issue は実装責務ごとに分け、主に従う guideline を明確にする。
必要な場合は、frontend、API、asset など複数の guideline を参照してよい。

## Tool Choice

本格的な個人開発では、まず Paper を優先する。
Figma は必要になった段階で検討する。

Paper が向いている場合:

- 生成画像から素早く画面構成を作りたい。
- Codex と一緒に UI を区画分解したい。
- 個人開発で軽く設計を回したい。
- 実装計画と Issue 分割が目的。
- Free プランの call 数を意識して一括作業できる。

Figma を検討する場合:

- 複数人で長期的に design system を管理する。
- component variant や design token を厳密に管理する。
- デザイナーとエンジニアで細かいレビューを続ける。
- 複数画面で同じ UI 部品を大量に再利用する。

Markdown だけでよい場合:

- 既存 UI の小さな延長で済む。
- 管理画面や CRUD 画面で装飾が少ない。
- Paper を使うほどの新しい画面構成がない。

## Planning Checklist

- UI 画像を区画に分解したか。
- 各区画の役割、必要データ、操作、状態を整理したか。
- 意味のある単位で component 候補を作ったか。
- Paper の tool call を節約する作業方針を決めたか。
- 既存 API と未実装 API を分けたか。
- component と API endpoint / data source の対応表を作ったか。
- 既存実装との差分から作業単位を切ったか。
- MVP に入れるものと後回しにするものを分けたか。
- 画像素材を切り抜く必要があるか判断したか。
- 素材の透明背景化、静的 asset 配置、framework への組み込み手順を決めたか。
- Markdown の実装計画を作ったか。
- 親 Issue / sub Issue に分割できる状態になっているか。
