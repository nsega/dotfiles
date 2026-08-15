# Dedupe PATH/fpath automatically (keeps the first occurrence, so prepends still win)
typeset -U path PATH fpath FPATH

export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/usr/local/sbin:$HOME/bin:/usr/local/bin:$PATH"
# Java: JDK 11 is the intended default (the generic openjdk keg only exists as a brew dependency)
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
# Claude Code Recommended: Create a new user-writable npm prefix
export PATH="$HOME/.npm-global/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

# Auto-update oh-my-zsh every 13 days
export UPDATE_ZSH_DAYS=13

# Show red dots while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Timestamp format for history output
HIST_STAMPS="mm/dd/yyyy"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew gem aws docker golang tmux kubectl kubetail kube-ps1 terraform)

# Go configuration
export GOPATH=$HOME
export GOROOT=/opt/homebrew/opt/go/libexec
export GOMODCACHE=$GOPATH/pkg/mod
export GOTOOLCHAIN=auto
export PATH=$GOROOT/bin:$PATH
export CLOUDSDK_PYTHON=$HOME/.pyenv/shims/python3
export GPG_TTY=$(tty)

export VOLTA_HOME=$HOME/.volta
export PATH=$VOLTA_HOME/bin:$PATH

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH=/opt/homebrew/opt/postgresql@17/bin:$PATH
export PATH=/opt/homebrew/opt/mysql-client/bin:$PATH
export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH

# Set the configuration for rbenv and pyenv
# rbenv is lazy-loaded: shims stay on PATH, the ~100ms init runs on first `rbenv` use
export PATH="$HOME/.rbenv/shims:$PATH"
rbenv() { unfunction rbenv; eval "$(command rbenv init - zsh)"; rbenv "$@"; }
eval "$(pyenv init - zsh)"

# Set the configuration for direnv
export EDITOR=/usr/bin/vi
eval "$(direnv hook zsh)"

export LANG=en_US.UTF-8

# Completion sources: everything goes on fpath BEFORE oh-my-zsh so its single
# compinit picks it all up in one pass (no other compinit call in this file)
fpath=(/opt/homebrew/share/zsh/site-functions /opt/homebrew/share/zsh-completions $fpath)
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
# End of Docker CLI completions

# stern/pixi completions are cached; regenerated only when the binary is newer
mkdir -p ~/.zfunc
fpath=(~/.zfunc $fpath)
if command -v stern >/dev/null && [[ ! ~/.zfunc/_stern -nt ${commands[stern]} ]]; then
  stern --completion=zsh > ~/.zfunc/_stern
fi
if command -v pixi >/dev/null && [[ ! ~/.zfunc/_pixi -nt ${commands[pixi]} ]]; then
  pixi completion --shell zsh > ~/.zfunc/_pixi
fi

source $ZSH/oh-my-zsh.sh

# Custom aliases (after oh-my-zsh to override its defaults)
alias ls='ls -a --color=auto'
alias ll='ls -alh --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias C='pbcopy'
alias p='cd $(ghq root)/$(ghq list | peco)'
alias b='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias v='code $(ghq root)/$(ghq list | peco)'
alias c='cursor $(ghq root)/$(ghq list | peco)'
alias ge='ghostty -e emacs &'

alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'

PROMPT=$PROMPT'$(kube_ps1) '

# Setting the emacs key-bind
bindkey -e

# Setting history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..

# completing the process name of ps command (state is the BSD keyword; s is GNU-only)
zstyle ':completion:*:processes' command 'ps x -o pid,state,args'

# Visible Japanese file name
setopt print_eight_bit

# Disable beep sound
setopt no_beep

# Disable flow_control
setopt no_flow_control

# '#' interactive comments
setopt interactive_comments

# cd by using only directory name
setopt auto_cd

# pushd automatically after cd
setopt auto_pushd
# ignore duplicated directory
setopt pushd_ignore_dups

# completing the path name after '='
setopt magic_equal_subst

setopt share_history
setopt hist_ignore_all_dups
setopt hist_save_nodups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt auto_menu
setopt extended_glob

bindkey '^R' history-incremental-pattern-search-backward

# peco + gh configuration
function peco-checkout-pull-request () {
    local selected_pr_id=$(gh pr list | peco | awk '{ print $1 }')
    if [ -n "$selected_pr_id" ]; then
        BUFFER="gh pr checkout ${selected_pr_id}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-checkout-pull-request

bindkey "^g^p" peco-checkout-pull-request

# install the shell completions of gcloud-cli (was the google-cloud-sdk cask)
source "/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc"
# add gcloud components of gcloud-cli to my PATH
source "/opt/homebrew/share/google-cloud-sdk/path.zsh.inc"
# kubectl completion comes from the oh-my-zsh kubectl plugin (cached, async);
# stern completion is cached in ~/.zfunc above

# activate the autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# activate the syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# 1Password CLI: inject secrets from template (cached, auto-refresh every 24h)
# Run `op-reload` to re-authenticate and refresh immediately
_OP_ENV_CACHE="$HOME/.cache/op_env_cache"
_OP_ENV_TPL="$HOME/src/github.com/nsega/dotfiles/.env.tpl"
_OP_CACHE_TTL=86400  # 24 hours in seconds
zmodload -F zsh/stat b:zstat  # mtime check via builtin; external stat is BSD unless coreutils is on PATH

if command -v op &>/dev/null && [[ -f "$_OP_ENV_TPL" ]]; then
  # Reuse the cache only if it is newer than the template and within TTL
  if [[ -f "$_OP_ENV_CACHE" && "$_OP_ENV_CACHE" -nt "$_OP_ENV_TPL" ]] && (( $(date +%s) - $(zstat +mtime "$_OP_ENV_CACHE") < _OP_CACHE_TTL )); then
    source "$_OP_ENV_CACHE"
  else
    mkdir -p "$(dirname "$_OP_ENV_CACHE")"
    if (umask 077 && op inject -i "$_OP_ENV_TPL" --account=my.1password.com > "$_OP_ENV_CACHE") 2>/dev/null; then
      source "$_OP_ENV_CACHE"
    else
      rm -f "$_OP_ENV_CACHE"
    fi
  fi
  # Cache persists across shell sessions; run `op-reload` to refresh manually
fi

op-reload() {
  rm -f "$_OP_ENV_CACHE"
  mkdir -p "$(dirname "$_OP_ENV_CACHE")"
  if (umask 077 && op inject -i "$_OP_ENV_TPL" --account=my.1password.com > "$_OP_ENV_CACHE"); then
    source "$_OP_ENV_CACHE"
    echo "1Password secrets reloaded."
  else
    rm -f "$_OP_ENV_CACHE"
    echo "Failed to reload 1Password secrets." >&2
  fi
}

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
