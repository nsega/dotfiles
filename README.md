# Dotfiles

Personal configuration files for macOS (Apple Silicon), optimized for DevOps and cloud engineering workflows.

## Contents

- **`.zshrc`** - Zsh shell configuration with Oh My Zsh framework
- **`.tmux.conf`** - Tmux terminal multiplexer configuration
- **`ghostty/config`** - Ghostty terminal emulator configuration (tmux alternative)
- **`.env.tpl`** - 1Password secret references (safe to commit, no actual secrets)
- **`.gitignore`** - Git ignore rules

## Features

### Zsh Configuration

- **Framework**: Oh My Zsh with `robbyrussell` theme
- **Version Managers**: rbenv, pyenv, direnv
- **Node.js**: Volta (primary), npm-global
- **Python**: pixi, micromamba (conda environments via `.conda_config`)
- **Plugins**: git, brew, gem, aws, docker, golang, tmux, kubectl, kubetail, kube-ps1, terraform
- **Cloud Tools**: Google Cloud SDK, AWS CLI
- **Kubernetes**: kubectl, stern, kube-ps1 for context display in prompt
- **Developer Tools**:
  - GitHub CLI (gh) with interactive PR checkout via peco
  - Peco for interactive filtering and selection
  - GHQ for repository management
  - Hub for GitHub operations
- **Custom Aliases**:
  - `p`: Navigate to projects using ghq + peco
  - `b`: Browse GitHub repository using hub + peco
  - `v`: Open project in VS Code using ghq + peco
  - `c`: Open project in Cursor using ghq + peco
  - `ge`: Open Emacs in Ghostty
  - `C`: Pipe output to clipboard (pbcopy)
  - Safety aliases: `rm -i`, `cp -i`, `mv -i`, `mkdir -p`
- **Enhanced Features**:
  - Syntax highlighting and autosuggestions
  - 1M entry command history with deduplication and timestamp
  - Case-insensitive completion matching
  - Auto-cd by directory name
  - Japanese file name support
  - Emacs-style keybindings
  - Docker CLI completions

### Tmux Configuration

- **Prefix**: `Ctrl-T` (instead of default Ctrl-B)
- **Default Shell**: Zsh
- **Mouse Support**: Enabled with scroll wheel
- **Clipboard**: macOS integration via `reattach-to-user-namespace`
- **Key Bindings**:
  - `Ctrl-T`: Next window
  - `v`: Vertical split
  - `h`: Horizontal split
  - `Shift+Arrow`: Navigate panes
  - `Prefix + r`: Reload config
- **History**: 5000 lines
- **Copy/Paste**: Ctrl-C/Ctrl-V for clipboard operations
- **Plugins** (via TPM):
  - tmux-resurrect (session save/restore)
  - tmux-continuum (auto-save every 15 min)

### Ghostty Configuration

Modern GPU-accelerated terminal emulator with native multiplexing (alternative to tmux):

- **Default Shell**: Zsh with native shell integration
- **Mouse Support**: Enabled with native clipboard integration
- **Prefix Key**: `Ctrl+T` (matching tmux configuration)
- **Key Bindings** (chord-based like tmux):
  - **Split Management**:
    - `Ctrl+T > H`: Split left
    - `Ctrl+T > J`: Split down
    - `Ctrl+T > K`: Split up
    - `Ctrl+T > L`: Split right
    - `Ctrl+T > F`: Toggle split zoom (maximize/restore)
    - `Ctrl+T > O`: Cycle through splits
    - `Ctrl+T > Space`: Equalize split sizes
  - **Navigation**:
    - `Shift+Arrow Keys`: Quick navigation between splits
    - `Ctrl+T > Arrow Keys`: Navigate between splits (prefix style)
  - **Tab Management**:
    - `Ctrl+T > N`: Next tab
    - `Ctrl+T > P`: Previous tab
    - `Ctrl+T > C`: Create new tab
  - **Clipboard**:
    - `Ctrl+T > Shift+C`: Copy to clipboard
    - `Ctrl+T > V`: Paste from clipboard
  - **Scrollback Navigation** (emacs-style, prefix-based):
    - `Ctrl+T > Ctrl+N`: Scroll down one line
    - `Ctrl+T > Ctrl+P`: Scroll up one line
    - `Ctrl+T > Ctrl+V`: Page down
    - `Ctrl+T > Alt+V`: Page up
    - `Ctrl+T > Alt+<`: Scroll to top
    - `Ctrl+T > Alt+>`: Scroll to bottom
  - **Other**:
    - `Ctrl+T > Alt+X`: Command palette
    - `Ctrl+T > R`: Reload configuration
- **Scrollback**: 100,000 lines
- **Terminal**: 256 color support (xterm-256color)
- **Font**: Monaco, 12pt (ligatures disabled)
- **Features**: GPU-accelerated rendering, native split panes, auto-update checks

## Secret Management

Secrets are managed via **1Password CLI** (`op`) using a template-based approach:

- `.env.tpl` contains `op://` references (no actual secrets) — safe to commit
- At shell startup, `op inject` resolves references and exports environment variables
- Touch ID authenticates once per session

### Adding a new secret

1. Store the secret in 1Password (vault: `Private`, account: `my.1password.com`)
2. Add a line to `.env.tpl`:
   ```
   export MY_SECRET={{ op://Private/item-name/password }}
   ```
3. Reload shell: `source ~/.zshrc`

### Finding 1Password item paths

```bash
op item list --account=my.1password.com | grep -i <keyword>
op item get "<item-name>" --account=my.1password.com
```

## Pre-commit Hooks

- **gitleaks** scans staged changes for accidental secret commits
- Install: `brew install gitleaks`

## Requirements

### Core Dependencies
- macOS (optimized for Apple Silicon)
- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- Zsh (default shell on macOS)

### Recommended Packages
```bash
# Terminal emulator and multiplexer
brew install ghostty              # Modern GPU-accelerated terminal (tmux alternative)
brew install tmux                 # Traditional terminal multiplexer
brew install peco
brew install reattach-to-user-namespace

# Version managers
brew install rbenv
brew install pyenv
brew install direnv
brew install pixi

# Node.js (Volta)
curl https://get.volta.sh | bash

# Git and GitHub tools
brew install ghq
brew install hub

# Kubernetes tools
brew install stern
brew install kube-ps1

# Programming languages
brew install go
brew install openjdk

# Database clients
brew install postgresql@17
brew install mysql-client

# GNU utilities
brew install gnu-sed
brew install coreutils

# Secret management
brew install --cask 1password-cli
brew install gitleaks

# Google Cloud SDK (via Cask)
brew install --cask google-cloud-sdk
```

### Zsh Plugins
```bash
# Zsh syntax highlighting
brew install zsh-syntax-highlighting

# Zsh autosuggestions
brew install zsh-autosuggestions
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/nsega/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Backup existing configurations (if any):
```bash
mv ~/.zshrc ~/.zshrc.backup
mv ~/.tmux.conf ~/.tmux.conf.backup
```

3. Create symlinks:
```bash
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf

# For Ghostty configuration
mkdir -p ~/.config/ghostty
ln -sf ~/dotfiles/ghostty/config ~/.config/ghostty/config
```

4. Install Oh My Zsh (if not already installed):
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

5. Install required dependencies (see Requirements section)

6. Reload your shell:
```bash
source ~/.zshrc
```

## Usage

### Zsh Features

**Interactive PR Checkout:**
- Press `Ctrl-G Ctrl-P` to interactively select and checkout a GitHub pull request using peco

**Project Navigation:**
- Use `p` alias to navigate to projects managed by ghq (uses peco for selection)
- Use `b` alias to browse GitHub repositories in your browser
- Use `v` alias to open projects in VS Code
- Use `c` alias to open projects in Cursor

**Kubernetes Context:**
- Current kubectl context displayed in prompt via kube-ps1

**Other Shortcuts:**
- `Ctrl-R`: History search with pattern matching
- `| C`: Pipe command output to clipboard
- Tab completion works case-insensitively

### Tmux Commands

**Basic Operations:**
- Start tmux: `tmux`
- New session: `tmux new -s <name>`
- Attach session: `tmux attach -t <name>`
- List sessions: `tmux ls`

**Window Management:**
- `Ctrl-T c`: Create new window
- `Ctrl-T`: Next window
- `Ctrl-T n`: Next window
- `Ctrl-T p`: Previous window

**Pane Management:**
- `Ctrl-T v`: Vertical split
- `Ctrl-T h`: Horizontal split
- `Shift+Arrow`: Navigate between panes

### Ghostty Usage

**Getting Started:**
- Launch Ghostty from Applications or via `ghostty` command
- Configuration loads automatically from `~/.config/ghostty/config`

**Split Management:**
- `Ctrl+T > H/J/K/L`: Create splits left/down/up/right (vim-style)
- `Shift+Arrow Keys`: Quick navigation between splits
- `Ctrl+T > Arrow Keys`: Navigate between splits (prefix style)
- `Ctrl+T > F`: Toggle split zoom (maximize/restore current split)
- `Ctrl+T > O`: Cycle through splits
- `Ctrl+T > Space`: Equalize split sizes
- Mouse click to focus a split

**Tab Management:**
- `Ctrl+T > N`: Switch to next tab
- `Ctrl+T > P`: Switch to previous tab
- `Ctrl+T > C`: Create new tab
- Mouse click on tab bar to switch tabs

**Clipboard Operations:**
- `Ctrl+T > Shift+C`: Copy selected text to clipboard
- `Ctrl+T > V`: Paste from clipboard
- Native macOS clipboard integration (no reattach-to-user-namespace needed)

**Scrollback Navigation (emacs-style):**
- `Ctrl+T > Ctrl+N/P`: Scroll down/up one line
- `Ctrl+T > Ctrl+V`: Page down
- `Ctrl+T > Alt+V`: Page up
- `Ctrl+T > Alt+<` / `Alt+>`: Jump to top/bottom

**Configuration:**
- `Ctrl+T > R`: Reload configuration without restarting
- `Ctrl+T > Alt+X`: Open command palette
- Edit `~/dotfiles/ghostty/config` to customize settings
- Changes take effect immediately after reload

**Note:** The `>` symbol indicates a chord sequence - press `Ctrl+T`, release, then press the next key (similar to tmux prefix behavior)

**Benefits over tmux:**
- GPU-accelerated rendering for better performance
- Native split panes without separate multiplexer process
- Direct clipboard integration without additional tools
- Modern UI with mouse support out of the box

## Configuration Details

### Environment Variables

The `.zshrc` configures the following environment variables:

- **GOPATH**: Set to `$HOME`
- **GOROOT**: Points to Homebrew Go installation
- **GOMODCACHE**: Set to `$GOPATH/pkg/mod`
- **GOTOOLCHAIN**: Set to `auto`
- **VOLTA_HOME**: Set to `$HOME/.volta`
- **CLOUDSDK_PYTHON**: Uses pyenv Python 3
- **GPG_TTY**: Configured for GPG signing
- **EDITOR**: Set to `/usr/bin/vi`
- **LANG**: Set to `en_US.UTF-8`

### Zsh Settings

- **History**: 1,000,000 entries with timestamp format `mm/dd/yyyy`
- **Oh My Zsh Updates**: Every 13 days
- **Completion**: Waiting dots enabled, case-insensitive matching
- **Behavior**: Auto-cd, auto-pushd, share history across sessions

### Paths

The configuration adds the following to PATH:
- `/opt/homebrew/bin` and `/opt/homebrew/sbin`
- `/opt/homebrew/opt/openjdk/bin` (Java)
- `/opt/homebrew/opt/openjdk@11/bin` (Java 11)
- `/opt/homebrew/opt/postgresql@17/bin` (PostgreSQL)
- `/opt/homebrew/opt/mysql-client/bin` (MySQL)
- `/opt/homebrew/opt/gnu-sed/libexec/gnubin` (GNU sed)
- `/opt/homebrew/opt/coreutils/libexec/gnubin` (GNU coreutils)
- `$HOME/.krew/bin` (kubectl plugins)
- `$HOME/.volta/bin` (Volta / Node.js)
- `$HOME/.pixi/bin` (pixi)
- `$HOME/.npm-global/bin` (npm global packages)
- `$HOME/.pyenv/shims/python` (Python)

## Customization

Feel free to fork and customize these configurations for your own needs:

- Modify the theme in `.zshrc` by changing `ZSH_THEME`
- Add/remove Oh My Zsh plugins in the `plugins` array
- Adjust tmux prefix key in `.tmux.conf`
- Customize Ghostty appearance and behavior in `ghostty/config`:
  - Change `font-family` and `font-size` for different fonts
  - Modify `theme` for different color schemes
  - Adjust keybindings to match your workflow
  - Configure `background-opacity` for transparency effects
- Add your own aliases and functions to `.zshrc`
- Add secrets to `.env.tpl` using 1Password `op://` references

## License

Personal configuration files - use at your own discretion.

## Author

nsega
