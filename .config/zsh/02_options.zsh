# ┌────────────────────────────────────────────────────────────────────────────┐
# │                           2. Zsh Core & Options                            │
# └────────────────────────────────────────────────────────────────────────────┘
# [CONFIG] Set the desired Oh My Zsh theme.
export ZSH_THEME="powerlevel10k/powerlevel10k"

# --- History Settings ---
# [CONFIG] Configure history behavior for a large and persistent command history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE="$HOME/.zsh_history"

# --- Zsh Options ---
# [INFO] Options for a better and more intuitive interactive experience.
setopt AUTO_CD              # Change directory without the 'cd' command.
setopt NOTIFY               # Instantly notify on background job completion.
setopt SHARE_HISTORY        # Share history between all open terminals.
setopt EXTENDED_GLOB        # Enable extended globbing features (e.g., '^' for negation).
setopt HIST_IGNORE_DUPS     # Don't save consecutive duplicate commands.
setopt HIST_IGNORE_SPACE    # Don't save commands starting with a space.

# --- Oh My Zsh Update Mode ---
# [INFO] Set Oh My Zsh update mode to 'reminder' to avoid auto-updates.
zstyle ':omz:update' mode reminder
