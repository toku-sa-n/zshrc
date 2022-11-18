# `readlink` fails if it reads a non-symbolic file without the `-m` option.
readonly ZSH_DIRECTORY=$(dirname $(readlink -m $HOME/.zshrc))

for f in zplug.zsh setopt.zsh envvar.zsh bindkey.zsh alias.zsh distro_spec.zsh prompt.zsh
do
    source $ZSH_DIRECTORY/$f
done
#sources{{{
#z command
command -v autojump >/dev/null 2>&1 && source /usr/share/autojump/autojump.zsh
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
#aliases {{{

chpwd(){
        ls --color=auto
}

# }}}


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
