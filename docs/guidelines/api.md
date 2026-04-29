# API Implementation Guidelines

SpotLog の API 実装では、Rails API の基本を学べる素直な REST 設計を優先する。
controller を薄く保ち、validation と database constraint の両方でデータを守る。

## Purpose

このガイドラインは、API 実装前に確認する判断基準として使う。
Rails API を単なる JSON 返却層にせず、アプリケーションの正しさと安全性を守る中核として設計するための最低限をまとめる。

## 基本方針

- MVP に必要な API だけを追加する。
- API は resource 中心で設計する。
- RESTful な route と HTTP method を使う。
- `namespace :api` と `resources` を基本にする。
- 新規 API 設計では `/api/v1` のように version を切る。SpotLog 既存 API は `/api` のため、移行は専用 Issue で扱う。
- 1 Issue では、endpoint・model・validation などの主目的をひとつに絞る。
- API 仕様、エラー形式、確認方法は PR に残す。
- 変更後は `docker compose exec backend bin/rubocop` と `docker compose exec backend bin/rails test` を確認する。

## Routes

- 標準的な CRUD は `resources` を使う。
- custom route は、REST では表現しにくい明確な理由がある場合だけ追加する。
- 一覧の絞り込みは query params を優先する。
- 例: `GET /api/spots?category_id=1`
- URL には実装都合ではなく、API 利用者から見た resource を表す名前を使う。
- URL に `create_spot` や `delete_spot` のような動詞を入れすぎない。
- nest は 1-2 階層を目安にし、深くしすぎない。

## Controllers

- controller は request params を受け取り、model / scope / query object を呼び、JSON を返す場所にする。
- 大きな business logic を controller に直接書かない。
- strong parameters を使い、`permit!` は使わない。
- render する JSON の形と HTTP status code を明確にする。
- create は成功時 `201 Created`、validation error は `422 Unprocessable Entity` を基本にする。
- destroy は成功時 `204 No Content` を基本にする。
- 共通の例外処理は、必要になったら `ApplicationController` に集約する。

## Models, Queries, and Services

- association は model に定義する。
- validation は model に書く。
- まずは model method や scope で表現し、一覧取得や絞り込みが複雑になったら query object への分離を検討する。
- scope や query object は、controller を読みやすくする目的で使う。
- 複数 model をまたぐ処理、外部 API 連携、transaction を含む処理は service への分離を検討する。
- 単純な CRUD では service を増やしすぎない。
- premature abstraction は避ける。

## Validation and Database Constraints

- 必須項目は model validation と DB constraint の両方で守る。
- `null: false`、`default:`、foreign key を適切に使う。
- `status` のような固定値は、model 側で許可値を検証する。
- default value は、domain 上自然なものだけにする。
- migration では既存 data への影響を確認する。
- schema 変更が必要な場合は、Issue の対象範囲と影響範囲に明記する。
- migration は意味単位で小さく、可能な限り reversible にする。
- index は主要導線から最小限で始める。遅さが見えたら SQL と `EXPLAIN` を根拠に追加する。

## JSON Responses

- API response は frontend が使いやすい形を優先する。
- 不要な内部情報を返さない。
- error response は、frontend が表示や分岐に使いやすい形にする。
- validation error は、可能な範囲で `{ message: "...", errors: { field: ["..."] } }` の形に揃える。
- 401 / 403 / 404 / 422 / 500 の意味を混ぜない。
- 認証エラー、認可エラー、validation error、想定外エラーの形式をできるだけ揃える。
- 一覧 API は、必要になった段階で pagination metadata を検討する。
- 小さい API では明示的な `render json:` でよい。
- response 形状が複数箇所で重複したり複雑になったら、serializer 的な object への分離を検討する。
- 1 回だけの単純な response のために serializer gem や重い抽象化を追加しない。

## Authentication and Authorization

- frontend から送られた `user_id` や権限に関わる値を信用しない。
- 認証と認可は分けて考える。
- 所有者確認・権限確認の最終判断は Rails API 側で行う。
- Pundit などの認可 gem は、認可ルールが増えてから検討する。
- 認証方式を入れる Issue では、Cookie / CSRF / CORS / Token の方針を先に決める。

## Security and Operations

- secret、token、password、Cookie、CSRF token を response や log に出さない。
- 外部 API 呼び出しは controller に直書きしない。
- 例外を握りつぶさず、想定外エラーは調査できる形にする。
- request id を追えると障害調査しやすい。
- 高度な監視基盤は MVP 初期では不要だが、ログに残してよい情報と出してはいけない情報は最初から区別する。

## Tests

- model validation と association は model test で確認する。
- endpoint の status code、response body、DB への反映は integration test で確認する。
- query params を追加したら、絞り込み条件の test を追加する。
- validation error と not found のような失敗系も確認する。
- 認証・認可を追加したら、401 / 403 相当の test を追加する。
- DB constraint を変える場合は、migration 後の test 実行まで確認する。

## Implementation Checklist

- この Issue の主目的はひとつに絞れているか。
- resource と HTTP method は自然か。
- response と error の形は既存 API と揃っているか。
- strong parameters は必要な項目だけを許可しているか。
- validation と DB constraint の両方で守るべき項目はないか。
- frontend から来た user id や権限値を信用していないか。
- migration / index は必要最小限か。
- 成功系と失敗系の test があるか。
