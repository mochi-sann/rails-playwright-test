# README

## UIを表示して動作確認する手順

1. 依存インストールとDB準備（未実行なら）
   - `bundle install`
   - `bin/rails db:prepare`
2. 開発サーバ起動
   - `bin/dev`（importmap + Turbo/Stimulus入りの標準構成）
3. ブラウザで `http://localhost:3000/` を開き、Todo一覧/作成/編集/削除/完了チェックを確認

## テスト実行手順

- RSpec（CIと同じコマンド）: `bundle exec rspec`
  - `spec/system` は `rack_test` ドライバを利用しておりブラウザ不要で実行可能です。

## UIを表示しつつE2Eテストを実行する方法

1. アプリ起動
   - `bin/rails db:prepare`
   - `bin/dev` を起動し、`http://localhost:3000/` をブラウザで開く（UI確認用）。
2. E2E（システム）テスト実行
   - 別ターミナルで以下を実行。
     - ヘッドレス実行（デフォルト）: `bundle exec rspec spec/system`
     - Chromeを表示して実行: `NO_HEADLESS=1 bundle exec rspec spec/system`
     - Chrome実行時はChrome/ChromeDriverが必要です（GitHub Actions などのホストには同梱されていることが多いですが、ローカルで不足している場合はインストールしてください）。
    - 環境によってCapybaraのTCPポートがブロックされる場合があります。そのときは `CAPYBARA_ALLOW_SERVER=1 NO_HEADLESS=1 bundle exec rspec spec/system` でSeleniumを許可するか、`CAPYBARA_DRIVER=rack_test bundle exec rspec spec/system` でブラウザなしにフォールバックしてください。

### ログイン前提の動作
- Todo閲覧・作成・編集・削除はログイン必須です。最初にサインアップしてログインしてください。
- 画面上のフラッシュで作成/更新/完了（更新）時のステータスが表示されます。
