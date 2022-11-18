#zplug {{{
#
# This zplug-related code are licensed under MIT license.
#
# The MIT License (MIT)
# Copyright © 2016-2020 Masaki Ishiyama <b4b4r07@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

[ -r $HOME/.zplug/init.zsh ] && source $HOME/.zplug/init.zsh

where zplug > /dev/null
if [ $? -ne 0 ]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check --verbose; then
    printf 'Install?[y/N]:'
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
# }}}
#Colors definition {{{
local DEFAULT=$'%{^[[m%}'$
local RED=$'%{^[[1;31m%}'$
local GREEN=$'%{^[[1;32m%}'$
local YELLOW=$'%{^[[1;33m%}'$
local BLUE=$'%{^[[1;34m%}'$
local PURPLE=$'%{^[[1;35m%}'$
local LIGHT_BLUE=$'%{^[[1;36m%}'$
local WHITE=$'%{^[[1;37m%}'$
# }}}
#setout{{{
setopt auto_param_slash
setopt mark_dirs
setopt list_types
setopt list_packed
setopt auto_menu
setopt auto_param_keys
setopt magic_equal_subst
setopt complete_in_word
setopt always_last_prompt
setopt print_eight_bit
setopt extended_glob
setopt globdots
setopt correct
setopt prompt_subst
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt no_flow_control
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
# }}}
#Environment paths{{{
export PATH="$HOME/cquery/build/release/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.6.0/bin:$HOME/.gem/ruby/2.4.0/bin:$HOME/.cargo/bin:$PATH:$HOME/go/bin:$HOME/.ghcup/bin"
export BSTINPUTS=$BSTINPUTS:/usr/share/texmf-dist/pbibtex/bst
export HISTFILE=$HOME/.histfile
export HISTSIZE=1000
export SAVEHIST=1000
export GPG_TTY=$(tty)
[[ -r "$HOME/.config/bat/syntaxes/Man.sublime-syntax" ]] && export MANPAGER="sh -c 'sed -e s/.\\\\x08//g|bat -l man -p'"
#}}}
#sources{{{
#z command
command -v autojump >/dev/null 2>&1 && source /usr/share/autojump/autojump.zsh
[[ -r "/etc/profile.d/cnf.sh" ]] && . /etc/profile.d/cnf.sh
[[ -r "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#}}}
#autoload{{{
#compinit{{{
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit
#}}}
autoload -U promptinit
promptinit
autoload -Uz colors
colors
# }}}
#bindkey{{{
bindkey -v

bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
bindkey -M viins '^F' forward-char
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^R' history-incremental-pattern-search-backward
#}}}
#prompt{{{

function zle-line-init zle-keymap-select {
    case $KEYMAP in
        vicmd)
            mode_indication="--- Normal ---"
            ;;
        main|viins)
            mode_indication="--- Insert ---"
            ;;
    esac
    export PROMPT="%(?..%{${fg[red]}Failed:${reset_color}%})[${fg[yellow]}%~${reset_color}] $mode_indication
%#"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
autoload -Uz vcs_info
precmd_vcs_info(){vcs_info}
precmd_functions+=( precmd_vcs_info )
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '+'
zstyle ':vcs_info:git:*' stagedstr '●'
zstyle ':vcs_info:git:*' formats '%b %u%c'  # %b: current branch, %u: unstagedstr, %c: stagedstr

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh && export FZF_DEFAULT_COMMAND='\find .'
# }}}
#aliases {{{

# fugitive.vim doesn't work well with symlinks. Working directory must have .git directory.
vim_expand_symlinks () {
    args=()
    for i in $@; do
        if [[ -h $i ]]; then
            args+=$(readlink $i)
        else
            args+=$i
        fi
    done

    \vim -p "${args[@]}"
}


alias vim="vim_expand_symlinks"

alias la='ls -aF --color=auto'
alias ll='ls -lahF --color=auto'
alias ls='ls -F --color=auto --group-directories-first'
alias l='ls'

alias df='df -h'
alias gcc='gcc -Ofast -pipe -march=native -fdiagnostics-color'
alias vi='vim'
alias ...='cd ../..'
alias ....='cd ../../..'
alias scroff='i3lock -c 000000 -e -f -u'
alias untargz='tar -zxvf'
alias fontlist=$'fc-list|awk -F \'[:]\' \'{print $2}\'|sort|uniq|sed \'s/ //\'|less'
alias irb='irb --simple-prompt'
alias grep='grep --color'
alias ping='ping -c3'

alias -g L='| less'
alias -g G='| grep'
alias -g F=' $(fzf)'

alias vrc="vim $HOME/.vimrc"
alias zrc="vim $HOME/.zshrc"
alias zpro="vim $HOME/.zprofile"
alias xrc="vim $HOME/.xinitrc"

alias ga="git add"
alias gb="git branch"
alias gbd="git branch --delete"
alias gc="git commit"
alias gck="git checkout"
alias gckb="git checkout -b"
alias gd="git diff"
alias gm="git merge"
alias gp="git push"
alias gpf="git push --force"
alias gpa="git push --all"
alias gpl="git pull"
alias gl="git log --graph --all"
alias gst="git status"  # gs command already exists. It will run GhostScript tool.
alias gsw="git switch"
alias gswc="git switch -c"
alias grt="git restore"
alias gr="git rebase"
alias grm="git rebase main"
alias grc="git rebase --continue"
alias cpr="gh pr create"
alias hs="hub sync"

alias v=vim

[ -x "$(command -v bat)" ] && alias cat='bat' && alias less='bat'
[ -x "$(command -v fuck)" ] && eval $(thefuck --alias) && alias f="fuck"
[ -x "$(command -v exa)" ] && alias ls='exa --group-directories-first'
[ -x "$(command -v fd)" ] && alias find="fd"
[ -x "$(command -v ack)" ] && alias grep='ack'
[ -x "$(command -v fzf)" ] && alias vf='vim $(fzf)'

alias :q='exit'
chpwd(){
        ls --color=auto
}

odp(){
    objdump --disassemble --demangle --disassembler-options=intel $1 | bat --language asm --style plain
}
# }}}
# Aliases which depends on the distribution using now{{{

arch(){
    alias detailpac='pacman -Qi'
    alias ns='sudo netctl start'
    alias inst='sudo pacman -S'
    alias unst='sudo pacman -Rs'
    alias upgr='yes|sudo pacman -Syu && common_upgr'
    alias paclist=$'pacman -Ql|awk -F " " \'{print $1}\'|uniq|less'
}

gentoo(){
    alias inst='sudo emerge -avt'
    alias unst='sudo emerge -cav'
}

(){
    local dist=$(cat /etc/*-release|grep '^ID'|awk -F '[=]' '{print $2}')

    case $dist in
        "arch" ) arch ;;
        "gentoo" ) gentoo;;
    esac
}
# }}}

[ -f "/home/hiroki/.ghcup/env" ] && source "/home/hiroki/.ghcup/env" # ghcup-env

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/hiroki/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/hiroki/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/hiroki/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/hiroki/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export FLYCTL_INSTALL="/home/hiroki/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
