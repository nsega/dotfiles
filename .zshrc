# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias la='ls -a'
alias ls='ls -a'
alias ll='ls -al'
alias -g ll='ls -al'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias g='cd $(ghq root)/$(ghq list | peco)'
alias b='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias v='code $(ghq root)/$(ghq list | peco)'

# Global Alias
alias -g L='| less'
alias -g G='| grep'

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bunder brew gem rbates)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="$HOME/bin:/usr/local/heroku/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.nodebrew/current/bin:/usr/local/pear/bin:$HOME/.rbenv/shims"
fpath=(/usr/local/share/zsh-completions $fpath)

## export add
export MANPATH="/usr/local/man:$MANPATH"
export GOPATH=$HOME
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT/bin
export DOCKER_HOST=tcp://$(boot2docker ip 2>/dev/null):2375

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export LANG=ja_JP.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Setting the emacs key-bind
bindkey -e

# History Settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
# compeltion after sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps command completion
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# Option Settings for zsh
setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt magic_equal_subst
setopt share_history
setopt hist_ignore_all_dups
setopt hist_save_nodups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt auto_menu
setopt extended_glob

# key-bind
bindkey '^R' history-incremental-pattern-search-backward

