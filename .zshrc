source ~/.bashrc

if ! runningon work; then
    export ZSH=$HOME/.oh-my-zsh
    ZSH_THEME="robbyrussell"
    plugins=(
        git
    )
    source $ZSH/oh-my-zsh.sh
fi

if runningon macos; then
    # Add Homebrew Ruby to PATH
    export PATH=$(echo /opt/homebrew/Cellar/ruby/*/bin(N)):"$PATH"
    # Add VLC to PATH
    export PATH="/Applications/VLC.app/Contents/MacOS:$PATH"
fi

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
export PATH="$HOME/go/bin:$PATH"

# Completion configuration
fpath[1,0]=~/.zsh/completion/
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
autoload -Uz compinit
compinit

ulimit -s unlimited

# Add Python user packages on macOS
if runningon macos; then
    for bindir in "$HOME"/Library/Python/*/bin(N); do
        # Prepend, so that newer Python versions are preferred and Python bins override system bins
        export PATH="$bindir:$PATH"
    done
fi

# Add Sublime Text to PATH on macOS
if runningon macos; then
    export PATH="$PATH:/Applications/Sublime Text.app/Contents/SharedSupport/bin"
fi

# Add VS Code to PATH on macOS
if runningon macos; then
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
fi

# Make other-writeable directories (e.g. on filesystems like FAT which don't have permission bit)
# appear like normal directories and not unreadable blue-on-green.
export LS_COLORS="$LS_COLORS:ow=01;34:"

# Default to Gnu binaries on macOS.
if runningon macos; then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"  # coreutils
    export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"       # grep
    export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"    # sed
    export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"    # tar
fi

# Show colors in ls output.
alias ls='ls --color=auto'

# Add JDK binaries to path on Linux and set JAVA_HOME
if runningon linux; then
    export PATH="$PATH:/usr/lib/jvm/java-11-openjdk/bin"
    export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
fi

# opam configuration
[[ ! -r /home/kerrick/.opam/opam-init/init.zsh ]] || source /home/kerrick/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

source ~/.zshrc_local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
