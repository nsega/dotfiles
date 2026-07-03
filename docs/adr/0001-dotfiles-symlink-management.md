# ADR 0001: dotfiles の配置管理は Makefile による symlink 方式とする

- **Status**: Accepted
- **Date**: 2026-07-03

## Context

dotfiles(`.zshrc` / `.tmux.conf` / `ghostty/config` / `herdr/config.toml`)をリポジトリ管理し、
実機の `$HOME` 配下へ反映する方法が必要。従来は README 記載の `ln -s` 手動実行だったが、
herdr 移行を機に以下の要件を整理した:

- デフォルトで全 dotfiles を一括リンク、オプションで個別リンクできること
- 既存の実ファイルを誤って上書きしないこと
- 冪等であること(何度実行しても安全)
- 現状の管理対象は 4 ファイル・1 台の Mac(Apple Silicon)

## Decision

**リポジトリ直下の Makefile で symlink を管理する。**

- `make`(デフォルト)で全 dotfiles をリンク、`make zsh|tmux|ghostty|herdr` で個別リンク
- リンク先に実ファイルがある場合は `<name>.backup` に退避してから `ln -sfn` で張る
- `make unlink` は symlink のみ削除(実ファイル・backup には触らない)
- リンク元は Makefile 自身の位置から絶対パスで解決(clone 先に依存しない)

## Alternatives Considered

| 方法 | 不採用の理由 |
|------|--------------|
| **GNU Stow** | symlink 管理としては Makefile と等価。パッケージ単位のディレクトリ再配置が必要になり、移行の手間に見合うメリットがない |
| **chezmoi** | 最有力の対抗馬。テンプレート・`chezmoi diff`・1Password 公式統合(`onepasswordRead`)が魅力だが、現在の規模(4 ファイル・1 台)ではオーバースペック。下記の再検討条件を満たしたら移行する |
| **bare git repo 方式**(`$HOME` を work-tree に) | symlink 自体を無くせるが、`~/.config/` 配下に散らばる配置では `.gitignore` 管理が神経質になる。gitleaks / entire の hook 運用とも相性が悪い |
| **Dotbot** | YAML で宣言的になるだけで機能は Makefile と同等。Python / submodule の依存が増えるだけ |
| **Nix home-manager** | 最も宣言的で強力だが学習コストが段違い。herdr 移行の学習と並行するには重すぎる |

## Consequences

- 依存ゼロ(make は macOS 標準)で、挙動が Makefile を読めば完全に把握できる
- 新しい設定ファイルを追加するたびに Makefile へターゲットを 1 つ追加する必要がある
- テンプレート機能はないため、マシンごとの差分吸収はできない(現状は不要)
- 秘密情報は引き続き `.env.tpl` + `op inject` + キャッシュの自前運用(本 ADR のスコープ外)

## Revisit Criteria

次のいずれかが起きたら **chezmoi への移行**を再検討する:

1. 管理対象マシンが 2 台以上になった(仕事用 Mac、VPS など)
   → テンプレートでマシン差分を吸収できる chezmoi が優位になる
2. `.env.tpl` + キャッシュの自前シェルスクリプト運用が辛くなった
   → chezmoi の 1Password 統合(`onepasswordRead`)に寄せられる

移行する場合も `chezmoi add` で 1 ファイルずつ段階的に取り込める(本リポジトリを
そのまま chezmoi のソースディレクトリにできる)ため、本決定がロックインになることはない。
