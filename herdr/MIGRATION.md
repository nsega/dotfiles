# tmux + Ghostty → herdr 移行プラン

[herdr](https://herdr.dev) は AI コーディングエージェント向けのターミナルマルチプレクサ（Rust 製シングルバイナリ）。
tmux の永続化（detach/attach）に加えて、Claude Code などのエージェント状態を
サイドバーで一覧できる（🔴 blocked / 🟡 working / 🔵 done / 🟢 idle）。

**移行の位置づけ**: herdr が置き換えるのは **tmux**。Ghostty はターミナルエミュレータとして継続使用し、その中で herdr を動かす。

## セットアップ手順

```bash
# 1. インストール（Homebrew）
brew install herdr

# 2. 設定ファイルをシンボリックリンク
mkdir -p ~/.config/herdr
ln -sf ~/dotfiles/herdr/config.toml ~/.config/herdr/config.toml

# 3. Claude Code 連携をインストール
#    ~/.claude/hooks/herdr-agent-state.sh を作成し settings.json にフックを追加。
#    ネイティブなセッション復元と状態レポートが有効になる
herdr integration install claude

# 4. 起動（バックグラウンドサーバが自動起動する）
herdr
```

初回起動時にオンボーディング画面が出る。完了すると `onboarding = false` が config に書き込まれる。

## キーバインド対応表（prefix: `Ctrl+T`）

tmux の操作感を維持するよう `config.toml` で調整済み。

| 操作 | tmux | herdr | 備考 |
|------|------|-------|------|
| プレフィックス | `C-t` | `ctrl+t` | 同じ |
| 次のタブ（window） | `prefix C-t` / — | `prefix+ctrl+t` / `prefix+n` | 同じ |
| 前のタブ | — | `prefix+p` | herdr デフォルト |
| 新しいタブ | `prefix c` | `prefix+c` | 同じ |
| 下に分割 | `prefix v` | `prefix+v`（`prefix+minus` も可） | 同じ |
| 右に分割 | `prefix h` | `prefix+h` | 同じ |
| ペイン移動 | `Shift+矢印` | `Shift+矢印`（`prefix+矢印` も可） | 同じ |
| ズーム | — | `prefix+z` | 新規 |
| ペインを閉じる | — | `prefix+x` | 新規 |
| コピーモード | `prefix [` | `prefix+[` | vim 操作（`v` 選択 / `y` コピー） |
| デタッチ | `prefix d` | `prefix+q` | **変更あり** |
| 設定リロード | `prefix r` | `prefix+shift+r` | **変更あり**（`prefix+r` はリサイズモード） |
| ワークスペース一覧 | — | `prefix+w` | herdr 固有の概念 |
| 新規ワークスペース | — | `prefix+shift+n` | プロジェクトごとに分ける |
| サイドバー表示切替 | — | `prefix+b` | エージェント状態一覧 |
| **Claude Code 新規ペイン** | — | `prefix+a` | カスタムバインド（カレントディレクトリで `claude` 起動） |
| 全キーバインド表示 | `prefix ?` | `prefix+?` | 同じ |

### tmux 機能の置き換え

| tmux の機能 | herdr での対応 |
|-------------|----------------|
| tmux-resurrect / tmux-continuum | サーバ常駐 + `[session] resume_agents_on_restore`（Claude Code はネイティブセッションごと復元） |
| `history-limit 1000000` | `scrollback_limit_bytes = 50MB` |
| `allow-passthrough` + bell（Claude Code 完了通知） | `[ui.toast] delivery = "terminal"`（Ghostty ネイティブ通知）+ サウンド |
| `default-shell /bin/zsh` | `[terminal] default_shell = "zsh"` |
| `split-window -c "#{pane_current_path}"` | `[terminal] new_cwd = "follow"` |
| reattach-to-user-namespace | 不要（ネイティブクリップボード対応） |

### 注意点

- prefix が `ctrl+t` なので、ペイン内アプリへ素の `Ctrl+T` は届かない（tmux 時代と同条件）。Claude Code の todo 表示トグル（`Ctrl+T`）を使いたい場合は prefix の再検討か直接バインドの追加を検討。
- Ghostty 側の `shift+arrow` split 移動キーバインドは、herdr 主体になったら **Phase 3 でコメントアウト**する（herdr へのキー到達を妨げるため）。

## 段階的移行プラン

### Phase 0: 準備（初日）

- [ ] `brew install herdr`
- [ ] config シンボリックリンク作成
- [ ] `herdr integration install claude`
- [ ] `herdr` を起動してオンボーディング完了
- [ ] `prefix+?` でキーバインド一覧を確認

### Phase 1: 並行運用（1 週目）

tmux は残したまま、新しい作業を herdr で始める。

- [ ] Ghostty の新しいウィンドウで `herdr` を起動して普段の作業をする
- [ ] 基本 5 操作を体に入れる: タブ作成 (`prefix+c`) / 分割 (`prefix+v`・`prefix+h`) / ペイン移動 (`Shift+矢印`) / デタッチ (`prefix+q`) / 再アタッチ (`herdr`)
- [ ] Claude Code を `prefix+a` で起動し、サイドバーの状態表示（🔴🟡🔵🟢）を確認
- [ ] `prefix+q` でデタッチ → `herdr` で再アタッチしてセッションが生きていることを確認

### Phase 2: Claude Code ワークフローの本格化（2 週目）

- [ ] ワークスペースをプロジェクト単位で使い分ける（`prefix+shift+n` / `prefix+w`）
- [ ] 複数の Claude Code を並列で走らせ、サイドバーで blocked のものから対応する運用を試す
- [ ] サイドバーから Git worktree を作成して、同一リポジトリで並列にエージェントを走らせる
- [ ] `herdr server stop` → `herdr` でサーバ再起動し、Claude Code セッションが復元されることを確認
- [ ] 通知（Ghostty toast + サウンド）が完了時に届くことを確認

### Phase 3: tmux からの卒業（3 週目〜）

- [ ] `.zshrc` に tmux 自動起動があれば herdr に変更（なければスキップ）
- [ ] Ghostty の `shift+arrow` goto_split キーバインドをコメントアウト（herdr に譲る）
- [ ] リモート運用を試す: `herdr --remote ssh://user@server`
- [ ] 2 週間問題なければ tmux/TPM 関連のセットアップを新規マシン手順から外す（`.tmux.conf` はリポジトリに残してよい）

### ロールバック

herdr はデータを持ち込まないので、いつでも `tmux` に戻れる。`.tmux.conf` は削除しない。

## 学習プラン

### Week 1: 基礎（tmux の代替として使えるようになる）

- 基本 5 操作（上記 Phase 1）を毎日使う
- 迷ったら `prefix+?`（キーバインド一覧）
- 公式ドキュメント: [Quick Start](https://herdr.dev/docs/quick-start/) → [Keyboard](https://herdr.dev/docs/keyboard/)
- 概念の理解: **Workspace > Tab > Pane** の 3 階層（tmux の session > window > pane に対応）と、サーバ/クライアント分離

### Week 2: エージェント運用（herdr 固有の価値を引き出す）

- エージェント状態検知の仕組みと 4 状態の意味を理解する
- セッション復元・worktree・通知を一通り試す（Phase 2 のチェックリスト）
- コピーモード（`prefix+[`、vim キー操作）に慣れる
- ドキュメント: [Agents](https://herdr.dev/docs/agents/) / [Persistence & Remote](https://herdr.dev/docs/persistence-remote/) / [Session State](https://herdr.dev/docs/session-state/)

### Week 3+: カスタマイズと応用

- `[[keys.command]]` で自分のワークフロー用ショートカットを追加（lazygit、k9s、テスト実行など）
- prefix-free 運用の検討: 頻出操作に `ctrl+alt+*` の直接バインドを併記して prefix 押下を省く
- Socket API / Agent Skill: Claude Code 自身に herdr のペイン分割・ワークスペース作成をさせる
  ```bash
  npx skills add ogulcancelik/herdr --skill herdr -g
  ```
- ドキュメント: [Socket API](https://herdr.dev/docs/socket-api/) / [Plugins](https://herdr.dev/docs/plugins/) / [CLI Reference](https://herdr.dev/docs/cli-reference/)

### 日常のリファレンス

```bash
herdr                        # 起動 / 再アタッチ
herdr session list           # セッション一覧
herdr session attach <name>  # 名前付きセッションにアタッチ
herdr server reload-config   # 設定リロード（または prefix+shift+r）
herdr server stop            # サーバ停止
herdr update                 # アップデート
herdr --default-config       # デフォルト設定の全量を表示
herdr config reset-keys      # キー設定をデフォルトに戻す（バックアップ付き）
```

ログ: `~/.config/herdr/herdr.log`（client / server も同ディレクトリ）
