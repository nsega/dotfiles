# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS (Apple Silicon), focused on DevOps/cloud engineering workflows. Contains shell, terminal multiplexer, and terminal emulator configurations.

## File Structure

- `.zshrc` - Zsh configuration with Oh My Zsh framework
- `.tmux.conf` - Tmux configuration (prefix: `Ctrl-T`, being replaced by herdr)
- `ghostty/config` - Ghostty terminal emulator (tmux alternative with native splits)
- `herdr/config.toml` - Herdr agent multiplexer (tmux replacement, prefix: `Ctrl+T`)
- `herdr/MIGRATION.md` - tmux → herdr migration plan and learning guide (Japanese)
- `Makefile` - Symlink installer (`make` = all, `make zsh|tmux|ghostty|herdr` = individual, `make unlink`)
- `docs/adr/` - Architecture Decision Records (Japanese; e.g. why Makefile symlinks over Stow/chezmoi)
- `.env.tpl` - 1Password secret references (safe to commit, no actual secrets)
- `.gitignore` - Git ignore rules

## Installation

Configs are symlinked to the home directory via the Makefile:
```bash
make          # link all configs (zsh, tmux, ghostty, herdr)
make herdr    # link one config (targets: zsh, tmux, ghostty, herdr)
make unlink   # remove the symlinks
```
Existing regular files are backed up to `<name>.backup` before linking.

After changes, reload with:
- Zsh: `source ~/.zshrc`
- Tmux: `prefix + r` or `tmux source-file ~/.tmux.conf`
- Ghostty: `Ctrl+T > r` or restart
- Herdr: `prefix + shift+r` or `herdr server reload-config`

## Key Configuration Patterns

### Zsh (.zshrc)
- Oh My Zsh plugins: git, brew, gem, aws, docker, golang, tmux, kubectl, kubetail, kube-ps1, terraform
- Version managers: rbenv, pyenv, nodenv (via eval init commands)
- Interactive tools: peco + ghq for project navigation
- GOPATH set to `$HOME`, GOROOT at `/opt/homebrew/opt/go/libexec`
- Kubernetes context shown in prompt via kube-ps1

### Tmux (.tmux.conf)
- Prefix: `Ctrl-T` (not default `Ctrl-B`)
- Uses `reattach-to-user-namespace` for macOS clipboard
- Plugins via TPM: tmux-resurrect, tmux-continuum (auto-save every 15 min)

### Ghostty (ghostty/config)
- Prefix: `Ctrl+T` (matching tmux)
- Chord-based keybindings: `ctrl+t>h/j/k/l` for splits (vim-style)
- Native clipboard integration (no reattach-to-user-namespace needed)
- Monaco font, 12pt

### Herdr (herdr/config.toml)
- Agent multiplexer replacing tmux; runs inside Ghostty
- Prefix: `Ctrl+T` (matching tmux); otherwise herdr default keybindings (`prefix+v` split right, `prefix+minus` split below, `prefix+h/j/k/l` pane focus)
- Custom bindings: `prefix+up/down` and `prefix+shift+1..9` switch workspaces, `prefix+,`/`prefix+.` cycle agents, `prefix+o` last pane, `prefix+a` new Claude Code pane
- Theme: catppuccin; agent labels shown on pane borders; new-tab name prompt disabled
- Agent session restore replaces tmux-resurrect/continuum; notifications via macOS Notification Center (`delivery = "system"`)
- Claude Code integration installed via `herdr integration install claude` (writes hook into `~/.claude`)
- Migration status and learning plan tracked in `herdr/MIGRATION.md`

## Custom Aliases

| Alias | Purpose |
|-------|---------|
| `p` | cd to project via ghq + peco |
| `v` | Open project in VS Code |
| `c` | Open project in Cursor |
| `ge` | Open Emacs in Ghostty |
| `b` | Browse GitHub repo in browser |
| `C` | Pipe output to clipboard (`\| C`) |

## Keybinding Reference

- `Ctrl-G Ctrl-P` - Interactive GitHub PR checkout (peco)
- `Ctrl-R` - History search with pattern matching

## Secret Management

Secrets are managed via **1Password CLI** (`op`) using a template-based approach with caching:

- `.env.tpl` contains `op://` references (no actual secrets) — safe to commit
- At shell startup, `op inject` resolves references and caches to `~/.cache/op_env_cache`
- Cache auto-refreshes every 24 hours or when `.env.tpl` changes (Touch ID prompted at most once per day)
- Cache created with `umask 077`; it persists across shell sessions
- Do not put unused `op://` references in `.env.tpl`, even commented out: `op inject` resolves references inside comment lines, so the secret still lands in the cache
- Run `op-reload` to manually refresh secrets

### Adding a new secret

1. Store the secret in 1Password (vault: `Private`, account: `my.1password.com`)
2. Add a line to `.env.tpl`:
   ```
   export MY_SECRET={{ op://Private/item-name/password }}
   ```
3. Refresh secrets: `op-reload`

### Finding 1Password item paths

```bash
op item list --account=my.1password.com | grep -i <keyword>
op item get "<item-name>" --account=my.1password.com
```

## Pre-commit Hooks

- **gitleaks** scans staged changes for accidental secret commits
- **entire** tracks development sessions and checkpoints
- Both run as local `.git/hooks/pre-commit` (not committed to repo)
- Install: `brew install gitleaks`

## Session Tracking (Entire)

- **Strategy**: `auto-commit` — automatically creates checkpoints
- **Config**: `.entire/settings.json` (committed), `.entire/settings.local.json` (gitignored)
- Re-enable: `entire enable --strategy auto-commit --force`
