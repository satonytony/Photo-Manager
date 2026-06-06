# remove-worktree

featureブランチのworktreeとローカルブランチを削除します。

## 使い方

```
/remove-worktree <feature番号-名前>
```

例:
- `/remove-worktree 3-photo-upload`
- `/remove-worktree 4-logout`

引数が省略された場合は確認してください。

## 実行手順

$ARGSから `FEATURE_NAME`（例: `3-photo-upload`）を取得してください。

以下を順番に実行してください：

### 1. worktree削除

```bash
git worktree remove /Users/nakao-satoshi/development/Photo-Manager-wt/feature-$FEATURE_NAME
```

### 2. ローカルブランチ削除

```bash
git branch -d feature/$FEATURE_NAME
```

`-d` でマージ未済のエラーが出た場合は、強制削除（`-D`）の前にユーザーに確認してください。

### 3. 完了報告

以下を出力してください：

```
worktreeを削除しました。

ブランチ:    feature/$FEATURE_NAME
ディレクトリ: ~/development/Photo-Manager-wt/feature-$FEATURE_NAME
```

エラーが発生した場合は原因を報告してください。
