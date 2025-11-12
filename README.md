# Dotfiles

Personal configuration files for macOS, optimized for DevOps and cloud engineering workflows.

## Contents

- **`.zshrc`** - Zsh shell configuration with Oh My Zsh framework
- **`.tmux.conf`** - Tmux terminal multiplexer configuration
- **`ghostty/config`** - Ghostty terminal emulator configuration (tmux alternative)

## Features

### Zsh Configuration

- **Framework**: Oh My Zsh with `robbyrussell` theme
- **Version Managers**: rbenv, nodenv, pyenv, direnv
- **Plugins**: git, brew, gem, aws, docker, golang, tmux, kubectl, kubetail, terraform
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
  - `Gl`: Open project in GoLand IDE
  - `i`: Open project in IntelliJ IDEA
  - `C`: Pipe output to clipboard (pbcopy)
  - Safety aliases: `rm -i`, `cp -i`, `mv -i`, `mkdir -p`
- **Enhanced Features**:
  - Syntax highlighting and autosuggestions
  - 1M entry command history with deduplication and timestamp
  - Case-insensitive completion matching
  - Auto-cd by directory name
  - Japanese file name support
  - Emacs-style keybindings

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

### Ghostty Configuration

Modern GPU-accelerated terminal emulator with native multiplexing (alternative to tmux):

- **Default Shell**: Zsh with native shell integration
- **Mouse Support**: Enabled with native clipboard integration
- **Key Bindings**:
  - `Ctrl+Shift+V`: Split vertically (down)
  - `Ctrl+Shift+H`: Split horizontally (right)
  - `Shift+Arrow`: Navigate between splits
  - `Ctrl+T`: Next tab
  - `Ctrl+Shift+T`: New tab
  - `Ctrl+Shift+C`: Copy to clipboard
  - `Ctrl+Shift+V`: Paste from clipboard
  - `Ctrl+Shift+R`: Reload configuration
- **Scrollback**: 5000 lines
- **Terminal**: 256 color support (xterm-256color)
- **Features**: GPU-accelerated rendering, native split panes, session management

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
brew install nodenv
brew install pyenv
brew install direnv

# Git and GitHub tools
brew install ghq
brew install hub

# Kubernetes tools
brew install stern

# Programming languages
brew install go
brew install openjdk
brew install python@3.8

# Google Cloud SDK (via Cask)
brew install --cask google-cloud-sdk
```

### Zsh Plugins
```bash
# Zsh syntax highlighting
brew install zsh-syntax-highlighting

# Zsh autosuggestions
brew install zsh-autosuggestions

# Kube-ps1 for Kubernetes context
brew install kube-ps1
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
- Use `Gl` or `i` aliases to open projects in GoLand/IntelliJ

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
- `Ctrl+Shift+V`: Create vertical split (split down)
- `Ctrl+Shift+H`: Create horizontal split (split right)
- `Shift+Arrow Keys`: Navigate between splits
- Mouse click to focus a split

**Tab Management:**
- `Ctrl+T`: Switch to next tab
- `Ctrl+Shift+T`: Create new tab
- Mouse click on tab bar to switch tabs

**Clipboard Operations:**
- `Ctrl+Shift+C`: Copy selected text to clipboard
- `Ctrl+Shift+V`: Paste from clipboard
- Native macOS clipboard integration (no reattach-to-user-namespace needed)

**Configuration:**
- `Ctrl+Shift+R`: Reload configuration without restarting
- Edit `~/dotfiles/ghostty/config` to customize settings
- Changes take effect immediately after reload

**Benefits over tmux:**
- GPU-accelerated rendering for better performance
- Native split panes without separate multiplexer process
- Direct clipboard integration without additional tools
- Modern UI with mouse support out of the box
- Session persistence built-in

## Configuration Details

### Environment Variables

The `.zshrc` configures the following environment variables:

- **GOPATH**: Set to `$HOME`
- **GOROOT**: Points to Homebrew Go installation
- **CLOUDSDK_PYTHON**: Uses Python 3.8 from Homebrew
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
- `$HOME/.krew/bin` (kubectl plugins)
- `$HOME/.pyenv/shims/python` (Python)
- `$HOME/.nodenv/shims/node` (Node.js)

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
- Update Python version in `CLOUDSDK_PYTHON` if using different Python version

## License

Personal configuration files - use at your own discretion.

## Author

nsega
