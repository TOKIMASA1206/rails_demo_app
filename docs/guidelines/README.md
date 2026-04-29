# Development Guidelines

このディレクトリは、SpotLog の実装前に確認する開発ガイドラインを置く場所。
Issue / PR の粒度、設計判断、レビュー観点をそろえ、変更を小さく安全に進めるために使う。

## Purpose

- frontend と backend の責務分離を明確にする。
- 実装前に確認すべき判断基準を短くまとめる。
- PR レビューで確認する観点をそろえる。
- MVP の範囲を保ちながら、将来の本格開発へ移行しやすい構成にする。

## Scope

このディレクトリには、実装時に繰り返し参照する基準だけを書く。
特定の Issue だけで必要になる詳細調査、長いコード例、技術選定メモは Issue 本文や PR 説明に残す。

## Included Topics

- Next.js と Rails API の責務分離
- Server Component / Client Component の境界
- API 呼び出し、型、error handling、cache の基本判断
- REST route、HTTP status、validation、DB constraint の基本判断
- 認証・認可・secret の安全境界
- Issue 分割、テスト、PR 確認に使う checklist

## Excluded Topics

- 詳細なコード例の全文
- 認証方式ごとの長い実装手順
- SWR / TanStack Query / Server Actions / Route Handler の詳細比較
- serializer / service / policy などの全パターン解説
- 監視、cache、外部 API、file upload の本格運用手順

## Documentation Rules

- 実装前の判断ミスを防ぐ内容は guideline に書く。
- 特定 Issue で初めて必要になる詳細は、Issue の調査メモや PR 説明に書く。
- 現在の SpotLog にない大きな設計変更は、専用 Issue を切ってから扱う。
- MVP の小ささを守るため、重要でも今すぐ不要な仕組みは「必要になったら検討」として残す。
- ガイドラインは、読み切れる長さを保つ。

## Maintenance

- 新しい実装で繰り返し同じ判断が発生したら、該当 guideline を更新する。
- 一度だけの判断や一時的なメモは、このディレクトリに追加しない。
- 既存ルールと矛盾する方針を追加する場合は、理由を PR に明記する。
