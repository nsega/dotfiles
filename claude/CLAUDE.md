# Global Instructions (all projects)

## Language

- 説明・議論・質問への回答は日本語で行う。
- コード、コメント、コミットメッセージ、PR タイトル / 本文は英語で書く。

## Environment

- macOS (Apple Silicon)。Homebrew は `/opt/homebrew` 配下。
- リポジトリは ghq で管理(`~/src/github.com/<owner>/<repo>`)。
- dotfiles は `Makefile` の symlink で `$HOME` に反映する(GNU Stow / chezmoi は使わない)。

## Safety

- kubectl / terraform / aws / gcloud を操作する前に、必ず対象を確認して報告する:
  - `kubectl config current-context`
  - `terraform workspace show`
  - `aws sts get-caller-identity`
- シークレットは 1Password CLI (`op`) + `.env.tpl` + キャッシュで管理している。
  シークレット値を `.env` やコードに直書きしない。シークレット値をチャットや
  コミットに出力しない。

## Git

- コミットは小さく分け、メッセージは英語の命令形で書く。
- main / master ブランチへ直接 push しない。
