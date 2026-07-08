source "$HOME/.pathrc"

# Begin added by argcomplete
fpath=( /opt/homebrew/share/zsh/site-functions "${fpath[@]}" )
# End added by argcomplete

if [[ -f "$HOME/.zshenv_local" ]]; then
    source "$HOME/.zshenv_local"
fi
