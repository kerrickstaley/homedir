#!/bin/bash

export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
export EDITOR=vim

git() {
    if [ "$(/usr/bin/env git rev-parse --show-toplevel 2>/dev/null)" != "$HOME" ] || [ "$1" = "clone" ]; then
        /usr/bin/env git "$@"
        return $?
    else
        echo "refusing to do git operation on home directory!"
        return 1
    fi
}

homegit() {
    if [ "$(/usr/bin/env git rev-parse --show-toplevel 2>/dev/null)" = "$HOME" ]; then
        /usr/bin/env git "$@"
        return $?
    else
        echo "this command only works for the home directory!"
        return 1
    fi
}

homegit-private() {
    homegit --git-dir=$HOME/.git-private --work-tree=$HOME "$@"
}

cgr() {
    # "change to git root"
    cd "$(git rev-parse --show-toplevel)"
}

csd() {
    # "change to sub directory"
    cd $(find * -type d | fzf)
}

if [[ -f ~/.bashrc_local ]]; then
    source ~/.bashrc_local
fi
