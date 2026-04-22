# Rails Demo App

Rails + Next.js + Docker + PostgreSQL を用いた、API開発とフロントエンド連携の学習用プロジェクトです。

このリポジトリは、Railsの基本構造（routes → controller → model → DB）を理解し、
実務に近い開発フロー（Docker / GitHub運用）を身につけることを目的としています。

---

## What is this app?

このアプリは以下を目的とした**学習用フルスタックアプリ**です。

* RailsのAPI設計の理解
* Next.jsとの連携の理解
* DBとのデータの流れの理解
* Dockerを使った再現可能な開発環境の構築
* GitHubを用いたチーム開発の練習

※ 現在は基盤構築フェーズ（API + frontend土台）

---

## Tech Stack

* Backend: Ruby on Rails
* Frontend: Next.js
* Database: PostgreSQL
* Environment: Docker / Docker Compose
* Version Control: Git / GitHub

---

## Directory Structure

```bash
.
├── backend/              # Railsアプリケーション
├── frontend/             # Next.jsアプリケーション
├── docker-compose.yml    # コンテナ定義
├── .env.example          # 環境変数サンプル
└── README.md
```

---

# Setup（初回セットアップ）

初めて環境を立ち上げるときのみ実行

## 1. 環境変数を作成

```bash
cp .env.example .env
```

---

## 2. Dockerコンテナ起動

```bash
docker compose up -d
```

---

## 3. DBを作成（初回のみ）

```bash
docker compose exec backend bundle exec rails db:create
```

---

## 4. マイグレーション実行

```bash
docker compose exec backend bundle exec rails db:migrate
```

---

## 5. 動作確認

```bash
Backend API: http://localhost:3000
Frontend:    http://localhost:3001
```

---

# Daily Development（通常の開発）

2回目以降はこれだけ

```bash
docker compose up -d
```

起動状態を確認したいとき:

```bash
docker compose ps
```

---

# Frontend

Next.js は Docker Compose の `frontend` サービスで起動します。

```bash
docker compose up -d frontend
```

ブラウザで確認:

```bash
http://localhost:3001
```

frontend の lint / build を確認したいとき:

```bash
docker compose exec frontend npm run lint
docker compose exec frontend npm run build
```

---

# CI

GitHub Actions で push / pull request 時に backend の `bin/rubocop` と `bin/rails db:test:prepare test` を実行します。

workflow ファイル:

```bash
.github/workflows/ci.yml
```

ローカルで CI 相当の確認をしたいとき:

```bash
docker compose exec backend bin/rubocop
docker compose exec backend bin/rails test
```

frontend の確認:

```bash
docker compose exec frontend npm run lint
docker compose exec frontend npm run build
```

---

# Development Flow（Git運用）

このプロジェクトでは以下のフローで開発します。

1. Issue作成
2. branch作成
3. 実装
4. Pull Request作成
5. mainへマージ

---

## ブランチ命名

```
<type>/<issue番号>-<内容>
```

例：

```
feat/2-add-user-api
docs/1-add-readme
```

---

## Commitルール

```
feat: 新機能
fix: バグ修正
docs: ドキュメント
refactor: リファクタリング
```

---

# Goal

* RailsでAPIを自力で設計できるようになる
* Next.jsと連携したフルスタック構成へ発展
* 実務レベルの開発フローに慣れる

---


# Author

Tokimasa Koda
バックエンドエンジニア志望 / Rails学習中
