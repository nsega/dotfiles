# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=${KREW_ROOT:-$HOME/.krew}/bin:/usr/local/opt/python/libexec/bin:$HOME/bin:/usr/local/bin:/usr/local/opt/ncurses/bin:$PATH


# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
alias ls='ls -a'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias p='cd $(ghq root)/$(ghq list | peco)'
alias b='hub browse $(ghq list | peco | cut -d "/" -f 2,3)'
alias v='code $(ghq root)/$(ghq list | peco)'
alias Gl='goland $(ghq root)/$(ghq list | peco)'

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
COMPLETION_WAITING_DOTS="true"

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
plugins=(git brew gem aws docker kubectl go golang tmux kubetail)

# User configuration
## export add
export GOPATH=$HOME
export GOROOT=/usr/local/opt/go/libexec
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH=$GOROOT/bin:$PATH

fpath=(/usr/local/share/zsh-completions $fpath)
eval "$(rbenv init -)"

## export configuration for direnv
export EDITOR=/usr/bin/vi
eval "$(direnv hook zsh)"

source $ZSH/oh-my-zsh.sh

# pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

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

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

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

# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

autoload -U compinit compdef
compinit
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
source <(kubectl completion zsh)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
