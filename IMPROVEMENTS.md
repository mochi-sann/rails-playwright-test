# Improvement Ideas

## ドメインとデータ品質
- `db/schema.rb` では `todos.title` や `todos.completed` が `NULL` を許容しており、`TodosController#index` の `where(completed: false)` では未設定レコードが漏れる。NOT NULL 制約と `completed` のデフォルト `false`、`title`/`due_date`/`priority` の制約を追加してデータ品質を底上げする。
- タグを `todos.tags` のカンマ区切り文字列で持っているため絞り込みが `LIKE` に頼っている。`todo_tags` 中間テーブルと `tags` マスタを導入し、`index_todo_tags_on_tag_id` を張ることで完全一致クエリやタグ集計が容易になる。
- 協業者モデル (`todo_collaborations`) は権限区別がなく owner と同じ権限になる。`role` カラムと `enum` を追加し、閲覧専用・編集可・共有可などの粒度を持たせることで共有機能を安全に拡張できる。

## アプリケーションロジック/UX
- `CommentsController#set_todo` と `TodosController#share` が `current_user.todos` に限定しているため、共有された Todo ではコメント投稿も再共有もできない。`current_user.accessible_todos` に統一し、権限チェックを Pundit/ActionPolicy 化する。
- `TodosController#index` にフィルタ条件がまとまっていて複雑化している。`TodosQuery`（service object）へ切り出し、Ransack 風の柔軟な検索や並び替えを追加することで API/UI ともに再利用しやすくする。
- 締切や優先度の視覚化がないため、一覧で `due_date` の残日数バッジや `priority` に応じた色分けを実装し、遅延タスクを一目で把握できるようにする。
- コメント投稿は Turbo Stream で置き換えているが、Todo 詳細ページに居なくてもリアルタイム更新は行われない。`broadcasts_to` を使って `todos#show` にライブ反映し、コラボレーション体験を向上させる。
- サブタスクの追加 UI は 1 行のみで並べ替え不可。`Stimulus` controller を追加して行の追加/削除・ドラッグ並べ替え・完了トグルを提供し、Playwright テストで回帰を抑える。

## テストと品質保証
- System spec は `spec/system/e2e_full_flow_spec.rb` など一部シナリオのみで、共有・コメント・検索・権限の回帰が担保されていない。`CAPYBARA_DRIVER=playwright` 前提の suite を追加して主要ユースケースを網羅する。
- リクエスト/モデルスペックでは `FactoryBot` が無く生データ生成をしている。`spec/support` に FactoryBot を導入して trait で completed/due soon などの状態を表し、テストの重複を削減する。
- `spec/support/allure_playwright.rb` は動画添付のみ対応している。Playwright のスクリーンショットや console log を `Allure` に添付し、CI 失敗時の調査コストを下げる。
- CI (`.github/workflows/ci.yml`) は Ruby 1 バージョンのみ／SQLite 固定。PostgreSQL/SQLite matrix、Playwright UI モード、`bin/rubocop`/`bin/brakeman` のキャッシュ共有などを追加し多環境での互換性を確認する。

## 開発体験と運用
- `bin/dev` は Rails サーバ単体を起動するだけなので、Tailwind や Playwright WebServer を使わない開発者が手順を覚える必要がある。`bin/setup` と `bin/dev`（`foreman`/`overmind`）を整備し、`bundle exec playwright install chromium` まで自動化する。
- `Dockerfile` では Playwright 依存ライブラリが入っていないため E2E をコンテナ内で実行できない。`apt-get install` に `libnss3` など CI と同じパッケージを追加し、`solid_queue` ワーカーも一緒に立ち上がるよう `CMD` を `./bin/rails server` + `./bin/rails solid_queue:start` に変更する。
- Dependabot は `bundler` と `github-actions` のみ対象なので、Playwright npm パッケージ（CI で `npm install playwright@1.57.0`）や Stimulus 関連の将来導入に備えて `npm` エコシステムも追加し、セキュリティリスクを早期検知する。
