# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for macOS (Apple Silicon), focused on DevOps/cloud engineering workflows. Contains shell, terminal multiplexer, and terminal emulator configurations.

## File Structure

- `.zshrc` - Zsh configuration with Oh My Zsh framework
- `.tmux.conf` - Tmux configuration (prefix: `Ctrl-T`)
- `ghostty/config` - Ghostty terminal emulator (tmux alternative with native splits)

## Installation

Configs are symlinked to home directory:
```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/ghostty/config ~/.config/ghostty/config
```

After changes, reload with:
- Zsh: `source ~/.zshrc`
- Tmux: `prefix + r` or `tmux source-file ~/.tmux.conf`
- Ghostty: `Ctrl+T > r` or restart

## Key Configuration Patterns

### Zsh (.zshrc)
- Oh My Zsh plugins: git, brew, gem, aws, docker, golang, tmux, kubectl, kubetail, terraform
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

## Custom Aliases

| Alias | Purpose |
|-------|---------|
| `p` | cd to project via ghq + peco |
| `v` | Open project in VS Code |
| `c` | Open project in Cursor |
| `Gl` | Open project in GoLand |
| `i` | Open project in IntelliJ IDEA |
| `b` | Browse GitHub repo in browser |
| `C` | Pipe output to clipboard (`\| C`) |

## Keybinding Reference

- `Ctrl-G Ctrl-P` - Interactive GitHub PR checkout (peco)
- `Ctrl-R` - History search with pattern matching
