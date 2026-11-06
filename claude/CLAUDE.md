# Dotfiles additions to the global instructions

<!-- Imported from ~/.claude/CLAUDE.md by `make claude`. Only add what the
     global file does not already say; do not copy its rules here. -->

## Language

- 説明・議論・質問への回答は、ユーザーが書いた言語で行う(日本語なら日本語、英語なら英語)。
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

- コミットは小さく分ける。
- main / master ブランチへ直接 push しない。
