#
# zsh config
# Date:	  2018/02/09
# Author: raf
#

export NAME='raf'
export FULLNAME=$NAME
export EMAIL="$USER@arista.com"
export REPLYTO=$EMAIL
export HISTFILE=~/.zsh_history
export LANG=en_US.UTF-8
export SAVEHIST=4096
export XDG_CONFIG_HOME=~/.config


if command most 2> /dev/null; then
    export PAGER="most"
elif command less 2> /dev/null; then
    export PAGER="less"
fi
if command nvim 2> /dev/null; then
    export EDITOR="nvim"
else
    export EDITOR="vim"
fi
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR
export PATH=$PATH:~/.local/bin:~/.local/usr/bin

[ "$USER" = "root" ] && export TMOUT=600

# LESS COLORS
export LESSCHARSET="utf-8"
export LESS_TERMCAP_mb=$(printf "\e[1;37m")
export LESS_TERMCAP_md=$(printf "\e[1;31m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;30m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")
export LESS=eFRX

# zsh opt
setopt appendhistory nomatch
setopt extended_glob
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt sh_word_split # Do not quote expanded vars
unsetopt beep notify

# Aliases
alias bright='xrandr --output eDP1 --brightness '
alias cp="cp -i"
alias df='df -h'
alias dot='PATH="$HOME/.config/dotgit/bin:$PATH" git --git-dir="$HOME/.config/dotgit/repo" --work-tree="$HOME"'
alias g='git'
alias grep='grep --color=tty -d skip'
alias gvim='vim -u ~/.vimrc.go'
alias l='ls -h -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias la='ls -h -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -h -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ls='ls --color=auto'
alias mkcd='_(){ mkdir $1; cd $1;}; _'
alias reload="source ~/.zshrc"
alias sso='ssh -A -l root'
alias unscp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias unssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias v=$EDITOR
alias vim=$EDITOR
alias zshrc='vim ~/.zshrc'

# Prompt
MD5CMD=`(which md5sum > /dev/null && echo "md5sum") ||
(which md5 > /dev/null && echo "md5") || echo "cat"`
if [ -z "$WP" ]; then
  HOST_COLOR="green"
else
   case `echo $(hostname) | $MD5CMD | sed -E 's/^(.).*$/\1/'` in
       "b"|"6"|"3"|"0")
           HOST_COLOR="red" ;;
       "1"|"8"|"7"|"f")
           HOST_COLOR="magenta" ;;
       "5"|"4"|"a")
           HOST_COLOR="yellow" ;;
       "2"|"9"|"d")
           HOST_COLOR="blue" ;;
       "f"|"c"|"e")
           HOST_COLOR="cyan" ;;
       *)
           HOST_COLOR="white" ;;
   esac
fi
PROMPT="%(!.%F{red}%B.%F{white})%n@%F{${HOST_COLOR}}%m%(!.%b.)%f:%F{cyan}%~%f%(?.%F{green}.%B%F{red})%#%f%b "
RPROMPT='%F{blue}%T%f %(?.%F{green}.%F{red}%B)%?%f'
#RPROMPT=$'$(vcs_info_wrapper)' $RPROMPT
setopt nopromptcr

# Misc
fpath=(~/.zsh/completion $fpath) 
autoload -U colors && colors
zstyle ':completion:*:default' list-colors ''

autoload -U compinit && compinit

# Git wrapper
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
        '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
        '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn
# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
    fi
}

export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
which dircolors > /dev/null && eval `dircolors`

# Fix keyboard
bindkey -e
bindkey '^W' vi-backward-kill-word
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '[D' emacs-backward-word
bindkey '[C' emacs-forward-word

# SSH agent
if [ -z $WP ]; then
   if [ ! -S ~/.ssh/ssh_auth_sock ]; then
       eval `ssh-agent`
       ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
   fi
   export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
   ssh-add -l | grep "The agent has no identities" && ssh-add
fi

function agent
{
  # Invoke GnuPG-Agent the first time we login.
  # Does `~/.gpg-agent-info' exist and points to gpg-agent process accepting signals?
  if test -f $HOME/.gpg-agent-info && \
    kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
    GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info | cut -c 16-`
  else
    # No, gpg-agent not available; start gpg-agent
    eval `gpg-agent --daemon --no-grab --write-env-file $HOME/.gpg-agent-info`
  fi
  export GPG_TTY=`tty`
  export GPG_AGENT_INFO
}

precmd() { echo -ne '\a'; } # notification when command end

# Arista stuff
func_file=~/.arista-functions.sh 
[ -e $func_file ] && source $func_file
