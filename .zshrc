# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.5.0/bin/"

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

if runningon work; then
    export PATH="$PATH:/usr/lib/go-1.10/bin"
fi

# this block prevents the Git status from being shown in the prompt for ~
# kudos to https://mharrison.org/post/bashfunctionoverride/
eval "$(declare -f git_prompt_info | sed '1s/git_prompt_info/git_prompt_info_orig/')"
git_prompt_info() {
    if [ "$(/usr/bin/env git rev-parse --show-toplevel 2>/dev/null)" != "$HOME" ]; then
        git_prompt_info_orig
    fi
}

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

cgr() {
    # "change to git root"
    cd "$(git rev-parse --show-toplevel)"
}

export EDITOR=vim

export GOPATH=~/go
export PATH="$HOME/go/bin:$PATH"

# Completion configuration
fpath[1,0]=~/.zsh/completion/
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
autoload -Uz compinit
compinit

ulimit -s unlimited

if runningon work && runningon linux; then
  export AWS_OKTA_BACKEND=file
fi

# Add Python user packages on macOS
if runningon macos; then
    for bindir in "$HOME"/Library/Python/*/bin; do
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
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"  # coreutils
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"       # grep
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"    # sed
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
