export WHALEBREW_INSTALL_PATH="$HOME/.whalebrew/bin"
if [[ ! -d "$WHALEBREW_INSTALL_PATH" ]]; then
    mkdir -p "$WHALEBREW_INSTALL_PATH"
fi

export PATH="$WHALEBREW_INSTALL_PATH:$PATH"
