# ┌────────────────────────────────────────────────────────────────────────────┐
# │                          4. FZF Configuration                              │
# └────────────────────────────────────────────────────────────────────────────┘
# [INFO] Speed up FZF by using 'fd' instead of the standard 'find'.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'

# --- Theming & Layout ---
# [CONFIG] Global settings for a beautiful and functional FZF with 'bat' previews.
export FZF_DEFAULT_OPTS='
--height 60% --layout=reverse --border=rounded
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--preview "bat --color=always --style=plain --line-range :500 {}"
--preview-window "right:55%:border-rounded"
'
