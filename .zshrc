# ╔══════════════════════════════════════════════════════════════╗
# ║                                                              ║
# ║                    ~/.zshrc - MAIN CONFIG                    ║
# ║                                                              ║
# ╚══════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────┐
# │               1. Environment & Path              │
# └──────────────────────────────────────────────────┘
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'                                 #  Set the default text editor
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:$HOME/.lmstudio/bin"

#  Custom environment variables for the "Metro" system
export DOTS="$HOME/.config"
export HYPR="$DOTS/hypr"

# ┌──────────────────────────────────────────────────┐
# │               2. Zsh & Oh My Zsh                 │
# └──────────────────────────────────────────────────┘
export ZSH_THEME="powerlevel10k/powerlevel10k"       #  Set the Zsh theme

#  History settings
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE            #  Ignore duplicate commands and commands starting with a space

#  Set Oh My Zsh update mode to 'reminder'
zstyle ':omz:update' mode reminder

# ┌──────────────────────────────────────────────────┐
# │                     3. Plugins                   │
# └──────────────────────────────────────────────────┘
#  List of plugins for Oh My Zsh to load
plugins=(
  git
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# ┌──────────────────────────────────────────────────┐
# │                     4. Aliases                   │
# └──────────────────────────────────────────────────┘

# --- 4.1. Package Management (Arch / yay) ---
alias update='yay -Syu'
alias install='yay -S'
alias remove='sudo pacman -Rns'
alias search='yay -Ss'

# --- 4.2. Utility Replacements ---
#  Viewing
alias ls='eza --icons --group-directories-first'     # Modern replacement for 'ls'
alias ll='eza -lh --icons --git --group-directories-first --header'
alias la='eza -lha --icons --git --group-directories-first --header'
alias cat='bat --paging=never --style=plain'         # Modern replacement for 'cat'
alias less='bat'

#  Analysis
alias lt='eza --tree --level=2 --icons'              # Tree view
alias lsz='eza -lrh --sort=size --icons'             # Sort by size
alias ld='eza -lrh --sort=modified --icons'          # Sort by date

#  Searching
alias find='fd'                                      # Modern replacement for 'find'
alias grep='rg'                                      # Modern replacement for 'grep'

#  Monitoring
alias top='btop'                                     # Modern replacement for 'top'
alias df='duf'                                       # Modern replacement for 'df'

# --- 4.3. Navigation & Convenience ---
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'

# --- 4.4. "Metro" System (Quick Navigation) ---
#  Navigation aliases are kept for convenience. Editing/viewing is now handled by functions.
alias goconf='cd $DOTS'
alias godunst='cd $DOTS/dunst'
alias gohome='cd ~'
alias gohypr='cd $HYPR'
alias gokitty='cd $DOTS/kitty'
alias goscripts='cd $HYPR/scripts'
alias gowaybar='cd $DOTS/waybar'
alias gowofi='cd $DOTS/wofi'

# --- 4.5. "Phoenix" Project (Dotfiles Management) ---
#  The dotgit function is the core of the dotfiles management system.
#   It must be defined before any aliases that use it.
dotgit() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

alias dstat='dotgit status'
alias dadd='dotgit add'
alias dcomm='dotgit commit -m'
alias dpush='dotgit push'
alias dlog='dotgit log --oneline --graph --decorate'

# =================================================================
#          dfind - Audit untracked configuration files
# =================================================================
dfind() {
    # --- 1. Find Files ---
    local untracked_files
    untracked_files=$(dotgit ls-files --others --exclude-standard -- ~/.config ~/.local/bin ~/.zshrc ~/.p10k.zsh)

    # --- 2. Display Results ---
    if [ -n "$untracked_files" ]; then
        # --- If files are found ---
        echo "┌─────────────────────────────   Git Audit ───────────────────────────────┐"
        echo "$untracked_files" | awk '
            BEGIN { first = 1 } {
                if (first) { prefix = "│ ┌ "; first = 0; } else { prefix = "│ ├ "; }
                lines[NR] = prefix $0;
            }
            END {
                sub(/├/, "└", lines[NR]);
                for (i = 1; i <= NR; i++) { print lines[i]; }
            }
        '
        echo "└──────────────────────────────────────────────────────────────────────────┘"
        echo "  Use 'dadd <path>' to add them to the next commit."
    else
        # --- If everything is clean ---
        echo "┌────────────────────   Git Audit  ────────────────────┐"
        echo "│                   ┌───────────────┐                   │"
        echo "│                   ├ System is up. ┤                   │"
        echo "│                   └───────────────┘                   │"
        echo "└───────────────────────────────────────────────────────┘"
    fi
}

# ┌──────────────────────────────────────────────────┐
# │                    5. Functions                  │
# └──────────────────────────────────────────────────┘

# =================================================================
#          Metro v5.1 "Bulletproof" - The Ultimate Config Editor
# =================================================================
# Combines the convenience of short aliases with a powerful file finder.
# This version uses a line-by-line definition to avoid Zsh globbing issues.

# --- Alias-to-Filename Translation Map (Bulletproof Definition) ---
typeset -A metro_aliases
metro_aliases[hypr]="hyprland.conf"
metro_aliases[binds]="keybinds.conf"
metro_aliases[rules]="window_rules.conf"
metro_aliases[look]="look.conf"
metro_aliases[colors]="colors.conf"
metro_aliases[paper]="hyprpaper.conf"
metro_aliases[pyrelayouts]="pyre_layouts.conf"
metro_aliases[hollywood]="hollywood.conf"
metro_aliases[hw]="hollywood.conf" # Alias for hollywood
metro_aliases[filemanager]="filemanager.conf"
metro_aliases[kitty]="pyre.conf" # Your main kitty config
metro_aliases[kittytheme]="theme.conf"
metro_aliases[waybar]="config"
metro_aliases[waybarstyle]="style.css"
metro_aliases[waybarcolors]="colors.css"
metro_aliases[wofistyle]="style.css"
metro_aliases[dunst]="dunstrc"
metro_aliases[ff]="config.jsonc"
metro_aliases[pyre]="pyre"
metro_aliases[zsh]=".zshrc"
metro_aliases[gitig]=".gitignore"

# --- Internal helper function to find the full path of a config file ---
_metro_find_config() {
    local target_file=$1
    local config_dirs=(
        "$HYPR" "$DOTS/kitty" "$DOTS/waybar" "$DOTS/dunst" "$DOTS/wofi"
        "$DOTS/fastfetch" "$DOTS" "$HOME/.local/bin" "$HOME"
    )
    for dir in "${config_dirs[@]}"; do
        if [[ -f "$dir/$target_file" ]]; then
            echo "$dir/$target_file"; return 0; fi
    done
    return 1
}

# --- Internal helper that resolves aliases OR uses direct names ---
_metro_resolve_path() {
    local input=$1
    local target_file

    # Check if the input is a known short alias
    if [[ -v "metro_aliases[$input]" ]]; then
        target_file=${metro_aliases[$input]}
    else
        # If not, assume the user typed the full filename
        target_file=$input
    fi

    # Find the full path of the resolved target file
    _metro_find_config "$target_file"
}

# --- The final 'edit' function ---
edit() {
    if [[ -z "$1" ]]; then echo "Usage: edit <alias_or_filename>"; return 1; fi
    if [[ "$1" == "p10k" ]]; then p10k configure; return 0; fi

    local found_path
    found_path=$(_metro_resolve_path "$1")

    if [[ -n "$found_path" ]]; then
        $EDITOR "$found_path"
    else
        echo "Config not found: $1"
        return 1
    fi
}

# --- The final 'view' function ---
view() {
    if [[ -z "$1" ]]; then echo "Usage: view <alias_or_filename>"; return 1; fi

    local found_path
    found_path=$(_metro_resolve_path "$1")

    if [[ -n "$found_path" ]]; then
        local lang
        case "${found_path##*.}" in
            conf)       lang="conf" ;;
            css)        lang="css" ;;
            jsonc|json) lang="json" ;;
            sh|zsh)     lang="sh" ;;
            gitignore)  lang="gitignore" ;;
            *)          lang="" ;;
        esac
        
        if [[ -n "$lang" ]]; then
            bat --paging=never -l "$lang" "$found_path"
        else
            bat --paging=never "$found_path"
        fi
    else
        echo "Config not found: $1"
        return 1
    fi
}

# =================================================================
#          slay - Find and kill processes by name
# =================================================================
# Usage: slay <process_name> (e.g., slay spotify)
slay() {
    if [ -z "$1" ]; then
        echo "Usage: slay <process_name>"
        return 1
    fi
    local pids
    pids=$(pgrep -fi "$1")
    if [ -z "$pids" ]; then
        echo "No processes found matching '$1'."
        return 0
    fi
    echo "Found PIDs: $pids"
    echo "Killing processes matching '$1'..."
    echo "$pids" | xargs kill -9
    echo "Done."
}

# =================================================================
#          gstat - Show git status for all repos in a directory
# =================================================================
# Usage: gstat (run it in your main projects folder)
gstat() {
    find . -maxdepth 2 -name ".git" -type d | while read -r gitdir; do
        local projectdir
        projectdir=$(dirname "$gitdir")
        echo ""
        echo "---   Status for: $projectdir ---"
        (cd "$projectdir" && git status -s)
    done
}

# =================================================================
#          extract - Decompress any archive
# =================================================================
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.rar)      unrar x "$1"    ;;
            *.gz)       gunzip "$1"     ;;
            *.tar)      tar xf "$1"     ;;
            *.zip)      unzip "$1"      ;;
            *.7z)       7z x "$1"       ;;
            *)          echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# =================================================================
#          mkcd - Create a directory and enter it
# =================================================================
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ┌──────────────────────────────────────────────────┐
# │             6. Initialization & Startup          │
# └──────────────────────────────────────────────────┘
#  Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

#  Load Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#  Load fzf key bindings and completions manually
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
