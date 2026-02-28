# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/opt/homebrew/sbin:/opt/homebrew/bin:/opt/homebrew/opt/openjdk/bin:$HOME/.krew/bin:/usr/local/sbin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.pyenv/shims/python:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.pixi/bin:$PATH"
# Claude Code Recommended: Create a new user-writable npm prefix
export PATH="$HOME/.npm-global/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Uncomment the following line if you want to activate
# insecure directories you can set the variable
ZSH_DISABLE_COMPFIX="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew gem aws docker golang tmux kubectl kubetail kube-ps1 terraform)

# User configuration

# Add export connfiguration
export GOPATH=$HOME
export GOROOT=/opt/homebrew/opt/go/libexec
export GOMODCACHE=$GOPATH/pkg/mod
export GOTOOLCHAIN=auto
export PATH=$GOROOT/bin:$PATH
export CLOUDSDK_PYTHON=$HOME/.pyenv/shims/python3
export GPG_TTY=$(tty)

export VOLTA_HOME=$HOME/.volta
export PATH=$VOLTA_HOME/bin:$PATH

export PATH=/opt/homebrew/opt/postgresql@17/bin:$PATH
export PATH=/opt/homebrew/opt/mysql-client/bin:$PATH
export PATH=/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH

# Set the configuration for rbenv and pyenv
eval "$(rbenv init -)"
eval "$(pyenv init -)"

# Set the configuration for direnv
export EDITOR=/usr/bin/vi
eval "$(direnv hook zsh)"

# Set the configuration for pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Custom aliases (after oh-my-zsh to override its defaults)
alias ls='ls -a --color=auto'
alias ll='ls -alh --color=auto'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias C='| pbcopy'
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

# compelting the command name after sudo command
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# completing the process name of ps command
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

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

autoload -U compinit compdef
compinit

# install the shell completions of google-cloud-sdk
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
# add gcloud components of google-cloud-sdk to my PATH
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source <(kubectl completion zsh)
source <(stern --completion=zsh)

# activate the autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# activate zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

eval "$(pixi completion --shell zsh)"

# activate the syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# 1Password CLI: inject secrets from template
if command -v op &>/dev/null && [[ -f ~/src/github.com/nsega/dotfiles/.env.tpl ]]; then
  eval "$(op inject -i ~/src/github.com/nsega/dotfiles/.env.tpl --account=my.1password.com)"
fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/naokisega/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/naokisega/Downloads/goog
le-cloud-sdk/completion.zsh.inc'; fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/naokisega/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# Conda micromamba configuration
export CONDACONFIGDIR=""
   cd() { builtin cd "$@" &&
   if [ -f $PWD/.conda_config ]; then
       export CONDACONFIGDIR=$PWD
       micromamba activate $(cat .conda_config)
   elif [ "$CONDACONFIGDIR" ]; then
       if [[ $PWD != *"$CONDACONFIGDIR"* ]]; then
           export CONDACONFIGDIR=""
           micromamba deactivate
       fi
   fi }

