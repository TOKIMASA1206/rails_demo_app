# Rails Demo App

Rails + Docker + PostgreSQL を用いた、バックエンドAPI開発の学習用プロジェクトです。

このリポジトリは、Railsの基本構造（routes → controller → model → DB）を理解し、
実務に近い開発フロー（Docker / GitHub運用）を身につけることを目的としています。

---

## What is this app?

このアプリは以下を目的とした**学習用APIサーバー**です。

* RailsのAPI設計の理解
* DBとのデータの流れの理解
* Dockerを使った再現可能な開発環境の構築
* GitHubを用いたチーム開発の練習

※ 現在は基盤構築フェーズ（API土台）

---

## Tech Stack

* Backend: Ruby on Rails
* Database: PostgreSQL
* Environment: Docker / Docker Compose
* Version Control: Git / GitHub

---

## Directory Structure

```bash
.
├── backend/              # Railsアプリケーション
├── docker-compose.yml    # コンテナ定義
├── .env.example          # 環境変数サンプル
└── README.md
```

---

# Setup（初回セットアップ）

👉 初めて環境を立ち上げるときのみ実行

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
http://localhost:3000
```

---

# Daily Development（通常の開発）

👉 2回目以降はこれだけ

```bash
docker compose up -d
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
