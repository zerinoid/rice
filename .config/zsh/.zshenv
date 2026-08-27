. "/home/zerinol/.local/share/cargo/env"

# ~/.zshenv
if [ -d "$HOME/.local/bin" ]; then
    typeset -U path PATH
    PATH="$PATH:$(find "$HOME/.local/bin" -type d | paste -sd ':' -)"
    export PATH
fi
