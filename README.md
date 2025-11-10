# Dotfiles

Personal configuration files for macOS, optimized for DevOps and cloud engineering workflows.

## Contents

- **`.zshrc`** - Zsh shell configuration with Oh My Zsh framework
- **`.tmux.conf`** - Tmux terminal multiplexer configuration

## Features

### Zsh Configuration

- **Framework**: Oh My Zsh with `robbyrussell` theme
- **Version Managers**: rbenv, nodenv, pyenv, direnv
- **Plugins**: git, brew, gem, aws, docker, golang, tmux, kubectl, kubetail, terraform
- **Cloud Tools**: Google Cloud SDK, AWS CLI
- **Kubernetes**: kubectl, stern, kube-ps1 for context display
- **Developer Tools**:
  - GitHub CLI (gh) with interactive PR checkout
  - Peco for interactive filtering
  - GHQ for repository management
- **Enhanced Features**:
  - Syntax highlighting and autosuggestions
  - 1M entry command history with deduplication
  - Safety aliases (rm, cp, mv with confirmation)
  - Custom project navigation with peco

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

## Requirements

### Core Dependencies
- macOS (optimized for Apple Silicon)
- [Homebrew](https://brew.sh/)
- [Oh My Zsh](https://ohmyz.sh/)
- Zsh (default shell on macOS)

### Recommended Packages
```bash
brew install tmux
brew install peco
brew install ghq
brew install stern
brew install direnv
brew install rbenv
brew install nodenv
brew install pyenv
brew install reattach-to-user-namespace
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
- Press `Ctrl-G` to interactively select and checkout a GitHub pull request

**Project Navigation:**
- Press `Ctrl-]` to navigate to projects managed by ghq

**Kubernetes Context:**
- Current kubectl context displayed in prompt via kube-ps1

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

## Customization

Feel free to fork and customize these configurations for your own needs:

- Modify the theme in `.zshrc` by changing `ZSH_THEME`
- Add/remove Oh My Zsh plugins in the `plugins` array
- Adjust tmux prefix key in `.tmux.conf`
- Add your own aliases and functions to `.zshrc`

## License

Personal configuration files - use at your own discretion.

## Author

nsega
