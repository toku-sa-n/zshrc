# `readlink` fails if it reads a non-symbolic file without the `-m` option.
readonly ZSH_DIRECTORY=$(dirname $(readlink -m $HOME/.zshrc))

for f in zplug.zsh \
    setopt.zsh \
    envvar.zsh \
    bindkey.zsh \
    alias.zsh \
    distro_spec.zsh \
    prompt.zsh \
    autojump.zsh \
    chpwd.zsh
do
    source $ZSH_DIRECTORY/$f
done
