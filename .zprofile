# Set PATH, MANPATH, etc., for Homebrew.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

source "$HOME/.pathrc"
[[ -f "$HOME/.zprofile_local" ]] && source "$HOME/.zprofile_local"
