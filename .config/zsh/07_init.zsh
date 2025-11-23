# ┌────────────────────────────────────────────────────────────────────────────┐
# │                          7. Initialization & Startup                       │
# └────────────────────────────────────────────────────────────────────────────┘
# [INFO] Robust initialization to prevent errors if a tool is not installed.

# --- Load Frameworks & Themes ---
source "$ZSH/oh-my-zsh.sh"
unalias g # [FIX] Oh My Zsh 'git' plugin creates a 'g' alias, we override it with our function.
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# --- Load FZF ---
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# --- Load Shell Integrations ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# --- Custom Keybindings ---
bindkey "^M" magic-enter
bindkey "^J" magic-enter
