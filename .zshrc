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
