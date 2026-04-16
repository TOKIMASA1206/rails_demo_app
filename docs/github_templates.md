# GitHub Template Structure

このリポジトリでは、GitHub 運用に関する定型文や役割を次のように分ける。

## 役割分担
- `AGENTS.md`
  - Codex に毎回守ってほしい作業ルール
  - ブランチ命名、コミット方針、実装時の注意点
- `.github/ISSUE_TEMPLATE/task.md`
  - Issue 作成時のテンプレート
  - 背景、目的、やること、完了条件、対象範囲、影響範囲を整理する
- `.github/pull_request_template.md`
  - PR 作成時のテンプレート
  - 概要、変更内容、確認方法、影響範囲、関連 Issue を整理する
- `docs/`
  - 運用メモや補足ドキュメント
  - テンプレートの意図や使い分けの説明

## 補足
- GitHub が自動で認識するテンプレートは、リポジトリ直下の `.github/` に置く。
- アプリ本体が `backend/` 配下にあっても、Issue / PR テンプレートはリポジトリ全体に効かせるため root に置く。
