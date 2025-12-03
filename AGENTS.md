# Repository Guidelines

## プロジェクト構成とモジュール配置
本リポジトリは Rails 8 + Hotwire + Importmap 構成です。`app/models`, `app/controllers`, `app/views` が MVC の中心で、Stimulus コントローラや Turbo Streams は `app/javascript` にまとまっています。認証付き Todo 機能は `app/controllers/todos_controller.rb` と `app/views/todos/` 配下で完結しており、ビューに対応する system spec は `spec/system` に置きます。プレゼンテーション用のスタイルや静的アセットは `app/assets`、Playwright 録画などの成果物は `tmp/` に生成されるため破棄可能です。

## ビルド・テスト・開発コマンド
開発環境の初期化は `bundle install && bin/rails db:prepare`、アプリ実行は `bin/dev`（Procfile.dev 経由で Rails と Vite 相当を起動）です。RSpec は `bundle exec rspec`、system spec で Playwright を使う場合は `CAPYBARA_ALLOW_SERVER=1 bundle exec rspec spec/system` を使い、UI を目視したいときは `NO_HEADLESS=1` を付けます。ブラウザ未導入時は `bundle exec playwright install chromium` を先に実行してください。静的解析は `bundle exec rubocop`、セキュリティスキャンは `bundle exec brakeman` を採用しています。

## コーディングスタイルと命名規約
Ruby/ERB は 2 スペースインデント、1 ファイル 1 クラスを基本とし、命令形のメソッド名と snake_case のローカル変数を使います。RSpec の describe/it には日本語でも良いですが、シナリオが明確になるよう “〜すること” で終わる文を推奨します。JS/Stimulus は camelCase の関数、data-controller は複合語をハイフンで繋げてください。フォーマットは Rubocop Omakase 設定に従い、自動修正は `bundle exec rubocop -A` を利用します。

## テスト指針
RSpec を単体・結合テストの標準とし、ファイル名は `*_spec.rb` で `spec/models`, `spec/requests`, `spec/system` に分類します。system spec では Capybara Playwright ドライバをデフォルト rack_test から切り替えるため `CAPYBARA_DRIVER=playwright` を必要に応じて設定し、動画を残す場合は `PLAYWRIGHT_RECORD=1` を付けます。テストに依存するデータは `spec/factories` か `let` で閉じ込め、各例は Given-When-Then コメントで可読性を担保してください。

## コミットとプルリクエスト
現状の Git 履歴は短いメッセージが多いため、今後は “Add todo filters” のように現在形・40 文字以内で要点を示すコミットを推奨します。PR では目的、主要変更点、確認手順、関連 Issue（`Fixes #123`）をテンプレ化し、UI 変更時はスクリーンショットや Playwright 録画のリンクを添付してください。提出前に `bundle exec rspec` と Rubocop/Brakeman を必ず通し、CI ログで失敗がないことを確認してからレビューを依頼します。

## セキュリティと設定メモ
`config/master.key` や `.env` に相当する秘密情報は共有せず、Playwright のポートが制限される環境では `CAPYBARA_DRIVER=rack_test` へフォールバックしてください。Docker で動かす場合は `Dockerfile` と `bin/rails db:prepare` の順で初期化し、SQLite ファイルは `db/` 以下なのでマウント時に権限を確保します。
