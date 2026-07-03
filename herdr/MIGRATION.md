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

prefix は tmux と同じ `Ctrl+T`。それ以外は herdr のデフォルトを採用し、ワークスペース / エージェント移動だけ独自バインドを追加している。

| 操作 | tmux | herdr | 備考 |
|------|------|-------|------|
| プレフィックス | `C-t` | `ctrl+t` | 同じ |
| 次のタブ（window） | `prefix C-t` | `prefix+n` | **変更あり** |
| 前のタブ | — | `prefix+p` | herdr デフォルト |
| 新しいタブ | `prefix c` | `prefix+c` | 同じ（タブ名プロンプトは無効化済み） |
| タブ切替（番号） | — | `prefix+1..9` | herdr デフォルト |
| 下に分割 | `prefix v` | `prefix+minus` | **変更あり** |
| 右に分割 | `prefix h` | `prefix+v` | **変更あり** |
| ペイン移動 | `Shift+矢印` | `prefix+h/j/k/l` | **変更あり**（vim スタイル） |
| 直前のペインに戻る | — | `prefix+o` | カスタム（tmux の `prefix o` に近い感覚） |
| ズーム | — | `prefix+z` | 新規 |
| ペインを閉じる | — | `prefix+x` | 新規 |
| コピーモード | `prefix [` | `prefix+[` | vim 操作（`v` 選択 / `y` コピー） |
| デタッチ | `prefix d` | `prefix+q` | **変更あり** |
| 設定リロード | `prefix r` | `prefix+shift+r` | **変更あり**（`prefix+r` はリサイズモード） |
| ワークスペース一覧 | — | `prefix+w` | herdr 固有の概念 |
| 新規ワークスペース | — | `prefix+shift+n` | プロジェクトごとに分ける |
| ワークスペース切替 | — | `prefix+up` / `prefix+down` | カスタム |
| ワークスペース切替（番号） | — | `prefix+shift+1..9` | カスタム |
| エージェント間移動 | — | `prefix+,` / `prefix+.` | カスタム（blocked なエージェントへ素早く移動） |
| **Claude Code 新規ペイン** | — | `prefix+a` | カスタム（カレントディレクトリで `claude` を起動、終了でペインも閉じる） |
| サイドバー表示切替 | — | `prefix+b` | エージェント状態一覧（ペイン枠にもラベル表示） |
| 全キーバインド表示 | `prefix ?` | `prefix+?` | 同じ |

### tmux 機能の置き換え

| tmux の機能 | herdr での対応 |
|-------------|----------------|
| tmux-resurrect / tmux-continuum | サーバ常駐 + エージェントセッション復元（`resume_agents_on_restore`、デフォルト有効。Claude Code はネイティブセッションごと復元） |
| `history-limit 1000000` | デフォルトのスクロールバック（約 10MB/ペイン）。足りなければ `[advanced] scrollback_limit_bytes` で拡張 |
| `allow-passthrough` + bell（Claude Code 完了通知） | `[ui.toast] delivery = "system"`（macOS 通知センター）+ サウンド（デフォルト有効） |
| `default-shell /bin/zsh` | 未設定（`$SHELL` = zsh を使用） |
| `split-window -c "#{pane_current_path}"` | デフォルト動作（新ペインは元ペインのディレクトリを引き継ぐ） |
| reattach-to-user-namespace | 不要（ネイティブクリップボード対応） |

### 注意点

- prefix が `ctrl+t` なので、ペイン内アプリへ素の `Ctrl+T` は届かない（tmux 時代と同条件）。Claude Code の todo 表示トグル（`Ctrl+T`）を使いたい場合は prefix の再検討か直接バインドの追加を検討。
- ペイン移動は tmux 時代の `Shift+矢印` から herdr デフォルトの `prefix+h/j/k/l` に変更した。Ghostty 側の `shift+arrow` goto_split バインドは Ghostty 自身の split 用なので、herdr のペイン内 TUI が `Shift+矢印` を必要とする場合はコメントアウトを検討（Phase 3）。

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
- [ ] 基本 5 操作を体に入れる: タブ作成 (`prefix+c`) / 分割 (`prefix+v` 右・`prefix+minus` 下) / ペイン移動 (`prefix+h/j/k/l`) / デタッチ (`prefix+q`) / 再アタッチ (`herdr`)
- [ ] `prefix+a` で Claude Code ペインを開き、サイドバーの状態表示（🔴🟡🔵🟢）とペイン枠のエージェントラベルを確認
- [ ] `prefix+q` でデタッチ → `herdr` で再アタッチしてセッションが生きていることを確認

### Phase 2: Claude Code ワークフローの本格化（2 週目）

- [ ] ワークスペースをプロジェクト単位で使い分ける（`prefix+shift+n` / `prefix+w` / `prefix+up`・`prefix+down` / `prefix+shift+1..9`）
- [ ] 複数の Claude Code を並列で走らせ、`prefix+,`・`prefix+.` で blocked なエージェントから順に対応する運用を試す
- [ ] サイドバーから Git worktree を作成して、同一リポジトリで並列にエージェントを走らせる
- [ ] `herdr server stop` → `herdr` でサーバ再起動し、Claude Code セッションが復元されることを確認
- [ ] 通知（macOS 通知センター + サウンド）が完了時に届くことを確認

### Phase 3: tmux からの卒業（3 週目〜）

- [ ] `.zshrc` に tmux 自動起動があれば herdr に変更（なければスキップ）
- [ ] Ghostty の `shift+arrow` goto_split キーバインドが不要になっていればコメントアウト（herdr のペイン内 TUI へキーを渡すため）
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
