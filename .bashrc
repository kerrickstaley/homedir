#!/bin/bash

export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
export EDITOR=vim

homegit() {
    git --git-dir=$HOME/.homegit --work-tree=$HOME "$@"
}

homegit-private() {
    git --git-dir=$HOME/.homegit-private --work-tree=$HOME "$@"
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
