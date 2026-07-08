# Symlink dotfiles into $HOME.
#
#   make            # link everything (default)
#   make zsh        # link only .zshrc
#   make tmux       # link only .tmux.conf
#   make ghostty    # link only ghostty/config
#   make herdr      # link only herdr/config.toml
#   make claude     # link only claude/ (Claude Code user config)
#   make unlink     # remove all symlinks created by this Makefile
#   make help       # show this list
#
# Existing regular files are backed up to <name>.backup before linking.

DOTFILES_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

# link <source> <target>: back up a real file at <target>, then symlink
define link
	@if [ -e "$(2)" ] && [ ! -L "$(2)" ]; then \
		mv "$(2)" "$(2).backup"; \
		echo "backup: $(2) -> $(2).backup"; \
	fi
	@ln -sfn "$(1)" "$(2)"
	@echo "link:   $(2) -> $(1)"
endef

# unlink <target>: remove only if it is a symlink
define unlink
	@if [ -L "$(2)" ]; then rm "$(2)"; echo "unlink: $(2)"; fi
endef

.PHONY: all zsh tmux ghostty herdr claude unlink help

all: zsh tmux ghostty herdr claude

zsh:
	$(call link,$(DOTFILES_DIR)/.zshrc,$(HOME)/.zshrc)

tmux:
	$(call link,$(DOTFILES_DIR)/.tmux.conf,$(HOME)/.tmux.conf)

ghostty:
	@mkdir -p "$(HOME)/.config/ghostty"
	$(call link,$(DOTFILES_DIR)/ghostty/config,$(HOME)/.config/ghostty/config)

herdr:
	@mkdir -p "$(HOME)/.config/herdr"
	$(call link,$(DOTFILES_DIR)/herdr/config.toml,$(HOME)/.config/herdr/config.toml)

# Link individual entries only — never symlink ~/.claude itself, because
# Claude Code writes runtime data there (sessions, auth, plugins, memory).
claude:
	@mkdir -p "$(HOME)/.claude"
	$(call link,$(DOTFILES_DIR)/claude/settings.json,$(HOME)/.claude/settings.json)
	$(call link,$(DOTFILES_DIR)/claude/CLAUDE.md,$(HOME)/.claude/CLAUDE.md)
	$(call link,$(DOTFILES_DIR)/claude/skills,$(HOME)/.claude/skills)
	$(call link,$(DOTFILES_DIR)/claude/hooks,$(HOME)/.claude/hooks)

unlink:
	$(call unlink,,$(HOME)/.zshrc)
	$(call unlink,,$(HOME)/.tmux.conf)
	$(call unlink,,$(HOME)/.config/ghostty/config)
	$(call unlink,,$(HOME)/.config/herdr/config.toml)
	$(call unlink,,$(HOME)/.claude/settings.json)
	$(call unlink,,$(HOME)/.claude/CLAUDE.md)
	$(call unlink,,$(HOME)/.claude/skills)
	$(call unlink,,$(HOME)/.claude/hooks)

help:
	@sed -n 's/^#   //p' $(MAKEFILE_LIST)
