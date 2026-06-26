source ~/.bashrc

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(
    git
    direnv
)
source $ZSH/oh-my-zsh.sh

if runningon linux; then
    # this file is present on some distros (Arch) but not needed on others (Ubuntu)
    if [ -e /etc/profile.d/vte.sh ]; then
        source /etc/profile.d/vte.sh
    fi
    pbpaste() {
        xclip -o -selection clipboard
    }
    pbcopy() {
        xclip -selection clipboard
    }
fi

export GOPATH=~/go

# Completion configuration
fpath[1,0]=~/.zsh/completion/
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
autoload -Uz compinit
compinit

ulimit -s unlimited

# Make other-writeable directories (e.g. on filesystems like FAT which don't have permission bit)
# appear like normal directories and not unreadable blue-on-green.
export LS_COLORS="$LS_COLORS:ow=01;34:"

# Show colors in ls output.
alias ls='ls --color=auto'

# Set JAVA_HOME on Linux.
if runningon linux; then
    export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
fi

# opam configuration
[[ ! -r /home/kerrick/.opam/opam-init/init.zsh ]] || source /home/kerrick/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# ~unlimited history
HISTSIZE=10000000
SAVEHIST=10000000

[ -f ~/.zshrc_local ] && source ~/.zshrc_local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

setopt INC_APPEND_HISTORY

if runningon vps; then
    export MUJOCO_GL=egl
fi

if runningon macos; then
    alias 7z=7zz
fi

# Certain ML jobs open a lot of files and hit "OSError: [Errno 24] Too many open files"; this fixes that.
ulimit -n 1000000

wtcd() {
    if [[ -z "$1" ]]; then
        echo "usage: wtcd <branch>" >&2
        return 1
    fi
    local wt
    wt=$(git worktree list --porcelain | awk -v b="refs/heads/$1" '
        /^worktree / { p = substr($0, 10) }
        /^branch / && $2 == b { print p; exit }
    ') || return 1
    if [[ -z "$wt" ]]; then
        echo "wtcd: no worktree for branch '$1'" >&2
        return 1
    fi
    cd "$wt"
}

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
