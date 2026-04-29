# Frontend Implementation Guidelines

SpotLog の frontend 実装では、学習しやすさとレビューしやすさを優先する。
大きな抽象化よりも、画面・状態・API 呼び出しの責務が読み取りやすい構成を選ぶ。

## Purpose

このガイドラインは、frontend 実装前に確認する判断基準として使う。
詳細な設計パターンをすべて覚えるためではなく、Next.js + Rails API 構成で責務を間違えないための最低限をまとめる。

## 基本方針

- 1 Issue では、見た目・データ取得・フォーム・テストなどの主目的をひとつに絞る。
- 既存の Next.js / React / Tailwind CSS の書き方に合わせる。
- Next.js は画面、ルーティング、ユーザー体験、Rails API 呼び出しに集中する。
- DB 更新、業務ロジック、認証・認可の最終判断は Rails API に置く。
- MVP に不要な機能やデモ用の飾りは追加しない。
- 画面から使われていないコード、仮の UI、不要な console 出力を残さない。
- 変更後は原則として `docker compose exec frontend npm run lint` を確認する。
- page 構成、routing、環境変数、Server Component / Client Component 境界を変更した場合は `docker compose exec frontend npm run build` も確認する。

## Server and Client Components

- App Router では、まず Server Component で作れるか考える。
- `"use client"` は、フォーム、クリック操作、ブラウザ API、localStorage、リアルタイム更新などが必要な小さい部品に閉じ込める。
- 表示だけの page / layout / list は、可能なら Server Component のままにする。
- Server Component から Client Component に渡す props は、シリアライズ可能な値にする。
- server-only な環境変数や API helper を Client Component から import しない。
- 既存画面が Client Component で作られている場合、Issue の目的外なら大きな Server Component 化はしない。

## Data Fetching

- 初期表示データは、可能なら Server Component から Rails API を呼んで取得する。
- 初期表示のためだけに `useEffect` を使わない。`useEffect` はブラウザ側の副作用や、既存の Client Component 内で必要な場合に限定する。
- SWR / TanStack Query は、再検証、ポーリング、楽観的更新、複雑な cache invalidation が必要になってから検討する。
- Server Actions は、DB を直接触る場所ではなく、Rails API を呼ぶ薄い層として使う。
- Route Handler は Rails API の代替にしない。Cookie 変換や薄い BFF が必要な場合だけ検討する。
- ユーザー依存データを扱う場合は、Next.js 側で意図せず cache しないよう方針を明示する。

## Component Design

- ページ全体の構成を持つ component と、表示部品の component を分ける。
- component 名は役割が分かる名前にする。
- 1 つの component が大きくなったら、次の責務を分離できないか確認する。
  - データ取得
  - フォーム入力
  - フィルタや並び替えの状態
  - 一覧 item / card 表示
  - loading / error / empty 表示
- props は必要な値だけを渡す。
- 汎用化は、同じ構造が複数箇所で必要になってから検討する。
- feature 固有の component / api / type は feature 配下に寄せ、複数 feature で使う型だけ `src/types` に置く。

Recommended feature structure:

```text
src/features/spots/
  components/
  api/
  types.ts
  mapper.ts
```

## State Management

- まずは React の `useState` / `useEffect` で扱う。
- global state library は、複数画面で共有する明確な必要が出るまで追加しない。
- loading / error / empty / success の UI 状態を意識して実装する。
- API 通信中の二重送信を防ぐため、送信中 state を持つ。
- form の初期値、送信値、リセット条件を component 内で読みやすく保つ。

## API Calls

- API base URL、JSON fetch、HTTP error handling は helper に寄せる。
- API helper は最初から大きな client にしない。
- Server Component / Server Action から使う API helper と、Client Component から使う API helper は分ける。
- MVP では既存の API 呼び出し経路を優先し、すべての Rails API endpoint を proxy するためだけに Route Handler を追加しない。
- Route Handler は Cookie handling、CORS simplification、internal API URL の隠蔽など、明確な理由がある場合だけ使う。
- component 側では、できるだけ「何を取得・送信するか」が分かる形にする。
- error message はユーザーに表示するものと、開発者が調査するものを混ぜすぎない。
- `fetch` の `ok` 判定を忘れない。
- API response の型と実際の JSON がずれる可能性を意識し、重要な API では mapper や runtime validation を検討する。

## UI and Accessibility

- 入力欄には `label` を付ける。
- button の disabled state、送信中表示、error 表示を用意する。
- レスポンシブ表示で text や button が崩れないか確認する。
- 色や余白は既存 UI のトーンに合わせる。
- 画面内テキストは、機能説明よりもユーザーが次に取る行動を分かりやすくする。

## Security Boundary

- ブラウザに secret、private API key、server-only な環境変数を出さない。
- frontend の表示制御は UX のためであり、認可の最終判断ではない。
- 編集ボタンを隠しても API は直接叩けるため、所有者確認や権限確認は Rails API 側で必ず行う。
- 学習用の暫定 user id や header は永続的な認証方式として扱わない。
- 認証が必要になったら、Cookie / CSRF / CORS / Token の方針を専用 Issue で決める。

## Tests

- UI を変更したら、壊れやすい状態から優先してテストする。
- 優先度は loading / error / empty / success / form submit の順で考える。
- API 通信を含む component test では、fetch mock を使う。
- テストがない段階では、lint / build とブラウザでの目視確認を最低限行う。

## Implementation Checklist

- この Issue の主目的はひとつに絞れているか。
- 本当に Client Component が必要か。
- 初期表示データを `useEffect` で取得していないか。
- server-only な値をブラウザ側に出していないか。
- loading / error / empty / success があるか。
- API helper、型、component の置き場所は今後追いやすいか。
