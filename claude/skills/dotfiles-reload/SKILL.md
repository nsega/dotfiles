---
name: dotfiles-reload
description: After editing dotfiles (.zshrc, .tmux.conf, ghostty/config, herdr/config.toml, claude/), determine which configs changed and reload them or tell the user how. Use after any dotfiles edit, or when the user asks how to apply dotfiles changes.
---

# Reload changed dotfiles

1. Find what changed: in the dotfiles repo run `git status --short` (and
   `git diff --stat HEAD` for committed-but-unapplied work).

2. For each changed config, apply the matching reload. Shell-state changes
   (zsh) cannot be applied from this process, so give the user the command to
   run themselves:

   | Config | How to reload |
   |--------|---------------|
   | `.zshrc` | User runs `source ~/.zshrc` in their shell |
   | `.tmux.conf` | `tmux source-file ~/.tmux.conf` (or prefix + `r`) |
   | `ghostty/config` | `Ctrl+T > r` in Ghostty, or restart Ghostty |
   | `herdr/config.toml` | `herdr server reload-config` (or prefix + `Shift+R`) |
   | `claude/CLAUDE.md`, `claude/skills/`, `claude/hooks/` | Takes effect on the next Claude Code session; a new skill or hook needs `make claude` first to link it |
   | `claude/settings.json` | Not installed automatically. The user runs `make claude-settings-diff` and merges the wanted entries into `~/.claude/settings.json` by hand |
   | `.env.tpl` | User runs `op-reload` (Touch ID required) |

3. If a config file is new (not yet symlinked), run `make <target>` in the
   dotfiles repo first, then reload.
