source "$HOME/.pathrc"

# Begin added by argcomplete
fpath=( /opt/homebrew/share/zsh/site-functions "${fpath[@]}" )
# End added by argcomplete

[[ -f "$HOME/.zshenv_local" ]] && source "$HOME/.zshenv_local"
