# Photo Manager

写真を管理する Rails 8 製の Web アプリケーションです。
ユーザー登録／ログイン認証に加え、MyTweet API との OAuth 連携機能を備えています。

## 動作環境

- **対応OS**: macOS / Linux
  - Windows はネイティブ非対応です。Windows で動かす場合は **WSL2 上の Linux 環境**を利用してください（`bin/` 配下のスクリプトが Unix 環境を前提としています）。
- **Ruby**: 3.4.9（[mise](https://mise.jdx.dev/) で管理）
- **Node.js**: 不要（JavaScript は importmap-rails で配信するためビルド工程はありません）
- 追加のシステムライブラリは不要です。

## 技術スタック

- Ruby on Rails 8.1.3
- Puma（アプリケーションサーバー）
- SQLite3（データベース）
- RSpec（テスト）

## セットアップ手順

### 1. リポジトリを取得

```sh
git clone <repository-url>
cd Photo-Manager
```

### 2. Ruby をインストール（mise）

本プロジェクトは [mise](https://mise.jdx.dev/) で Ruby のバージョンを管理しています。
`mise.toml` に記載された Ruby 3.4.9 を導入します。

```sh
mise install
```

> mise が未インストールの場合は、先に [mise 公式サイト](https://mise.jdx.dev/getting-started.html) の手順に従ってインストールしてください。

### 3. 環境変数ファイル（.env）を作成

`.env.example` をコピーして `.env` を作成し、各値を記入します。
`.env` は起動時に自動で読み込まれます（`config/boot.rb`）。

```sh
cp .env.example .env
```

| 変数名 | 必須 | 説明 |
| --- | :---: | --- |
| `MY_TWEET_AUTHORIZE_URL` | ✓ | MyTweet OAuth 認可エンドポイント |
| `MY_TWEET_TOKEN_URL` | ✓ | MyTweet OAuth トークンエンドポイント |
| `MY_TWEET_API_URL` | ✓ | MyTweet API エンドポイント |
| `MY_TWEET_SCOPE` | ✓ | 要求するスコープ |
| `MY_TWEET_CLIENT_ID` | ✓ | OAuth クライアントID |
| `MY_TWEET_CLIENT_SECRET` | ✓ | OAuth クライアントシークレット |

### 4. 依存 gem のインストールとデータベース準備

```sh
bundle install
bin/rails db:prepare
```

`bundle install` で依存 gem を導入し、`bin/rails db:prepare` でデータベースの作成・スキーマ読み込み・シードデータ投入を行います。

シードデータでは、ログイン用のテストユーザー（`test@example.com` / `password`）が作成されます。

## サーバーの起動とアクセス

```sh
bin/rails server
```

起動後、ブラウザで以下にアクセスします。

```
http://localhost:3000
```

- ログイン: `test@example.com` / `password`
- ポートを変更する場合: `bin/rails server -p 4000`

## テストの実行

```sh
bundle exec rspec
```

## 補足: データベースについて

本プロジェクトは **SQLite3** を採用しているため、別途データベースサーバーを用意する必要はありません（データは `storage/` 配下にファイルとして生成されます）。

**MySQL や PostgreSQL を使う場合は、別途対応が必要です**（データベースサーバーの用意、`Gemfile` のアダプタ gem の差し替え、`config/database.yml` の書き換えなど）。

## トラブルシュート

- **サーバーが起動しない**: `.env` の必須変数がすべて設定されているか確認してください（未設定の場合、起動時に `ENV.fetch` で失敗します）。
- **Windows で動かない**: Windows ネイティブは未対応です。WSL2 上の Linux 環境を使用してください。
