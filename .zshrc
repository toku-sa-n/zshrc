# `readlink` fails if it reads a non-symbolic file without the `-m` option.
readonly ZSH_DIRECTORY=$(dirname $(readlink -m $HOME/.zshrc))

for f in zplug.zsh setopt.zsh envvar.zsh bindkey.zsh
do
    source $ZSH_DIRECTORY/$f
done
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

chpwd(){
        ls --color=auto
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
