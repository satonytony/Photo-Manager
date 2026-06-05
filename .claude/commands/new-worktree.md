# new-worktree

新しいfeatureブランチのworktreeを作成し、Rails開発できる状態にセットアップします。

## 使い方

```
/new-worktree <feature番号-名前> [ベースブランチ]
```

例:
- `/new-worktree 3-photo-upload feature/2-photos`
- `/new-worktree 4-logout feature/3-photo-upload`

引数が省略された場合は確認してください。

## 実行手順

$ARGSから `FEATURE_NAME`（例: `3-photo-upload`）と `BASE_BRANCH`（例: `feature/2-photos`）を取得してください。

以下を順番に実行してください：

### 1. ディレクトリ作成・worktree追加

```bash
git worktree add -b feature/$FEATURE_NAME /Users/nakao-satoshi/development/Photo-Manager-wt/feature-$FEATURE_NAME $BASE_BRANCH
```

### 2. master.key コピー

```bash
cp /Users/nakao-satoshi/development/Photo-Manager/config/master.key \
   /Users/nakao-satoshi/development/Photo-Manager-wt/feature-$FEATURE_NAME/config/master.key
```

### 3. mise trust

```bash
/opt/homebrew/bin/mise trust /Users/nakao-satoshi/development/Photo-Manager-wt/feature-$FEATURE_NAME
```

### 4. DB準備・シードデータ投入

```bash
cd /Users/nakao-satoshi/development/Photo-Manager-wt/feature-$FEATURE_NAME
/opt/homebrew/bin/mise exec -- bin/rails db:prepare db:seed
```

### 5. 起動確認

```bash
/opt/homebrew/bin/mise exec -- bin/rails runner 'puts "OK: Rails #{Rails.version}, User: #{User.count}"'
```

### 6. 完了報告

以下を出力してください：

```
worktreeの準備が完了しました。

ブランチ:    feature/$FEATURE_NAME
ディレクトリ: ~/development/Photo-Manager-wt/feature-$FEATURE_NAME
ベース:      $BASE_BRANCH
```

エラーが発生した場合は原因を報告してください。
