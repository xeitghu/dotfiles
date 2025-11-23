# ┌────────────────────────────────────────────────────────────────────────────┐
# │                           1. Environment & Path                            │
# └────────────────────────────────────────────────────────────────────────────┘
# [INFO] Using 'typeset -U path' automatically removes duplicate entries.
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.spicetify"
    "$HOME/.lmstudio/bin"
    $path
)
export PATH

# --- Core Variables ---
# [INFO] Core environment variables for scripts and applications.
export ZSH="$HOME/.oh-my-zsh"
export DOTS="$HOME/.config"
export HYPR="$DOTS/hypr"

# [CONFIG] Disable OMZ permission checks to speed up loading
export ZSH_DISABLE_COMPFIX="true" 

# [CONFIG] Set your default text editor.
export EDITOR='nvim'


