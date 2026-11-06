# Symlink dotfiles into $HOME.
#
#   make            # link zsh, tmux, ghostty and herdr (default; not claude)
#   make zsh        # link only .zshrc
#   make tmux       # link only .tmux.conf
#   make ghostty    # link only ghostty/config
#   make herdr      # link only herdr/config.toml
#   make claude     # link Claude Code skills and hooks, import claude/CLAUDE.md
#   make claude-settings-diff  # compare ~/.claude/settings.json with claude/settings.json (read-only)
#   make unlink     # remove all symlinks created by this Makefile
#   make help       # show this list
#
# Existing regular files are backed up to <name>.backup before linking.
# The claude target backs up to <name>.backup.YYYYmmddHHMMSS instead.

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

# Claude Code: ~/.claude is owned by Claude Code, herdr and the user, so only
# single skill directories and hook scripts are linked. settings.json is never
# linked or written, and CLAUDE.md gets an import line instead of a symlink.
CLAUDE_DIR     := $(HOME)/.claude
CLAUDE_SRC     := $(DOTFILES_DIR)/claude
CLAUDE_ENTRIES := $(patsubst $(CLAUDE_SRC)/%/,%,$(wildcard $(CLAUDE_SRC)/skills/*/)) \
                  $(patsubst $(CLAUDE_SRC)/%,%,$(wildcard $(CLAUDE_SRC)/hooks/*.sh))
CLAUDE_IMPORT  := @$(patsubst $(HOME)/%,~/%,$(CLAUDE_SRC))/CLAUDE.md

# Shell snippet: symlink "$$dst" to "$$src". Anything else already at "$$dst"
# (file, directory or foreign symlink) is first moved to
# "$$dst.backup.YYYYmmddHHMMSS"; an existing backup is never overwritten.
LINK_ENTRY = \
	if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
		echo "ok:     $$dst -> $$src"; \
	else \
		if [ -e "$$dst" ] || [ -L "$$dst" ]; then \
			bak="$$dst.backup.$$(date +%Y%m%d%H%M%S)"; \
			if [ -e "$$bak" ] || [ -L "$$bak" ]; then \
				echo "error:  $$bak already exists, leaving $$dst alone" >&2; exit 1; \
			fi; \
			mv "$$dst" "$$bak" || exit 1; \
			echo "backup: $$dst -> $$bak"; \
		fi; \
		ln -s "$$src" "$$dst" || exit 1; \
		echo "link:   $$dst -> $$src"; \
	fi

# Shell snippet: fail if "$$path" is a symlink. A linked ~/.claude/skills,
# ~/.claude/hooks or ~/.claude/CLAUDE.md would make writes land in whatever it
# points to, possibly this repo.
NOT_SYMLINK = \
	if [ -L "$$path" ]; then \
		echo "error:  $$path is a symlink to $$(readlink "$$path"); replace it with a real file or directory first" >&2; exit 1; \
	fi

.PHONY: all zsh tmux ghostty herdr claude claude-settings-diff unlink help

all: zsh tmux ghostty herdr

zsh:
	$(call link,$(DOTFILES_DIR)/.zshrc,$(HOME)/.zshrc)

tmux:
	$(call link,$(DOTFILES_DIR)/.tmux.conf,$(HOME)/.tmux.conf)

ghostty:
	@mkdir -p "$(HOME)/.config/ghostty"
	$(call link,$(DOTFILES_DIR)/ghostty/config,$(HOME)/.config/ghostty/config)

herdr:
	@mkdir -p "$(HOME)/.config/herdr" "$(HOME)/.local/bin"
	$(call link,$(DOTFILES_DIR)/herdr/config.toml,$(HOME)/.config/herdr/config.toml)
	$(call link,$(DOTFILES_DIR)/herdr/bin/herdr-focus-attention,$(HOME)/.local/bin/herdr-focus-attention)

claude:
	@for path in "$(CLAUDE_DIR)/skills" "$(CLAUDE_DIR)/hooks" "$(CLAUDE_DIR)/CLAUDE.md"; do \
		$(NOT_SYMLINK); \
	done
	@mkdir -p "$(CLAUDE_DIR)/skills" "$(CLAUDE_DIR)/hooks"
	@for entry in $(CLAUDE_ENTRIES); do \
		src="$(CLAUDE_SRC)/$$entry"; dst="$(CLAUDE_DIR)/$$entry"; \
		$(LINK_ENTRY); \
	done
	@md="$(CLAUDE_DIR)/CLAUDE.md"; \
	if [ -f "$$md" ] && grep -qxF '$(CLAUDE_IMPORT)' "$$md"; then \
		echo "ok:     $$md imports $(CLAUDE_IMPORT)"; \
	else \
		{ [ -s "$$md" ] && echo; echo '$(CLAUDE_IMPORT)'; } >> "$$md" || exit 1; \
		echo "import: $$md += $(CLAUDE_IMPORT)"; \
	fi
	@if [ -L "$(CLAUDE_DIR)/settings.json" ]; then \
		echo "warning: $(CLAUDE_DIR)/settings.json is a symlink to $$(readlink "$(CLAUDE_DIR)/settings.json"); Claude Code rewrites this file, so make it a real file" >&2; \
	fi
	@echo "note:   settings.json is not installed; run 'make claude-settings-diff' and merge entries by hand"

# Read-only: print a key-sorted diff of your settings against the reference
# copy. Only temporary files are written.
claude-settings-diff:
	@command -v jq >/dev/null 2>&1 || { echo "error:  jq is required (brew install jq)" >&2; exit 1; }
	@cur="$(CLAUDE_DIR)/settings.json"; [ -f "$$cur" ] || cur=/dev/null; \
	tmp="$$(mktemp -d)" || exit 1; \
	jq -S . "$$cur" > "$$tmp/yours" && jq -S . "$(CLAUDE_SRC)/settings.json" > "$$tmp/repo" && \
	diff -u -L "~/.claude/settings.json" -L "claude/settings.json" "$$tmp/yours" "$$tmp/repo"; \
	rm -rf "$$tmp"; true

unlink:
	$(call unlink,,$(HOME)/.zshrc)
	$(call unlink,,$(HOME)/.tmux.conf)
	$(call unlink,,$(HOME)/.config/ghostty/config)
	$(call unlink,,$(HOME)/.config/herdr/config.toml)
	$(call unlink,,$(HOME)/.local/bin/herdr-focus-attention)
	@for entry in $(CLAUDE_ENTRIES); do \
		src="$(CLAUDE_SRC)/$$entry"; dst="$(CLAUDE_DIR)/$$entry"; \
		if [ -L "$$dst" ] && [ "$$(readlink "$$dst")" = "$$src" ]; then \
			rm "$$dst" && echo "unlink: $$dst"; \
		fi; \
	done

help:
	@sed -n 's/^#   //p' $(MAKEFILE_LIST)
