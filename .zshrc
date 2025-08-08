# ╔══════════════════════════════════════════════════════════════╗
# ║                                                              ║
# ║                    ~/.zshrc - MAIN CONFIG                    ║
# ║                                                              ║
# ╚══════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────┐
# │               1. Environment & Path              │
# └──────────────────────────────────────────────────┘
#  Using a `typeset -U path` array automatically prevents duplicate entries,
#   which is a cleaner way to manage the PATH variable.
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.spicetify"
    "$HOME/.lmstudio/bin"
    $path
)
export PATH

export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'                                   #  Set the default text editor

#  Custom environment variables for the "Metro" system
export DOTS="$HOME/.config"
export HYPR="$DOTS/hypr"

# ┌──────────────────────────────────────────────────┐
# │               2. Zsh & Oh My Zsh                 │
# └──────────────────────────────────────────────────┘
export ZSH_THEME="powerlevel10k/powerlevel10k"         #  Set the Zsh theme

#  History settings
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE              #  Ignore duplicate commands and those starting with a space

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
  zsh-completions #  RECOMMENDED: Adds a vast collection of completions for various tools.
)

# ┌──────────────────────────────────────────────────┐
# │                     4. Aliases                   │
# └──────────────────────────────────────────────────┘

# --- 4.1. Package Management (Arch / yay) ---
alias update='yay -Syu'
alias install='yay -S'
#  IMPROVEMENT: Added the `-i` flag for interactive confirmation before removing packages.
alias remove='sudo pacman -Rnsi'
alias search='yay -Ss'

# --- 4.2. Utility Replacements ---
#  Viewing
alias ls='eza --icons --group-directories-first'                      # Modern replacement for 'ls'
alias ll='eza -lh --icons --git --group-directories-first --header'
alias la='eza -lha --icons --git --group-directories-first --header'
alias cat='bat --paging=never --style=plain'                          # Modern replacement for 'cat'
alias less='bat'

#  Analysis
alias lt='eza --tree --level=2 --icons'                               # Tree view
alias lsz='eza -lrh --sort=size --icons'                              # Sort by size
alias ld='eza -lrh --sort=modified --icons'                           # Sort by date

#  Searching
alias find='fd'                                                       # Modern replacement for 'find'
alias grep='rg'                                                       # Modern replacement for 'grep'

#  Monitoring
alias top='btop'                                                      # Modern replacement for 'top'
alias df='duf'                                                        # Modern replacement for 'df'

# --- 4.3. Navigation & Convenience ---
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'

# --- 4.4. Quick Navigation ---
alias goconf='cd $DOTS'
alias godunst='cd $DOTS/dunst'
alias gohome='cd ~'
alias gohypr='cd $HYPR'
alias gokitty='cd $DOTS/kitty'
alias goscripts='cd $HYPR/scripts'
alias gowaybar='cd $DOTS/waybar'
alias gowofi='cd $DOTS/wofi'

# --- 4.5. Dotfiles Management ---
#  A wrapper function to manage dotfiles in a bare Git repository.
dotgit() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
alias dstat='dotgit status'
alias dadd='dotgit add'
alias ddel='dotgit rm'
alias dsee='dotgit ls-files | eza --tree --icons'
alias dcomm='dotgit commit -m'
alias dpush='dotgit push'
alias dlog='dotgit log --oneline --graph --decorate'

# ┌──────────────────────────────────────────────────┐
# │                    5. Functions                  │
# └──────────────────────────────────────────────────┘

# =================================================================
#          dfind - Audit untracked configuration files
# =================================================================
dfind() {
    local untracked_files
    untracked_files=$(dotgit ls-files --others --exclude-standard -- ~/.config ~/.local/bin ~/.zshrc ~/.p10k.zsh)
    if [ -n "$untracked_files" ]; then
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
        echo "┌────────────────────   Git Audit  ────────────────────┐"
        echo "│                   ┌───────────────┐                   │"
        echo "│                   ├ System is up. ┤                   │"
        echo "│                   └───────────────┘                   │"
        echo "└───────────────────────────────────────────────────────┘"
    fi
}

# ==============================================================
#                          Metro System
# ==============================================================
#  Maps short aliases to their corresponding config filenames for the `edit` and `view` functions.
typeset -A metro_aliases
metro_aliases[hypr]="hyprland.conf"
metro_aliases[binds]="keybinds.conf"
metro_aliases[rules]="window_rules.conf"
metro_aliases[look]="look.conf"
metro_aliases[colors]="colors.conf"
metro_aliases[paper]="hyprpaper.conf"
metro_aliases[pyrelayouts]="pyre_layouts.conf"
metro_aliases[hollywood]="hollywood.conf"
metro_aliases[hw]="hollywood.conf"
metro_aliases[filemanager]="filemanager.conf"
metro_aliases[kitty]="pyre.conf"
metro_aliases[kittytheme]="theme.conf"
metro_aliases[waybar]="config"
metro_aliases[waybarstyle]="$DOTS/waybar/style.css"
metro_aliases[waybarcolors]="$DOTS/waybar/colors.css"
metro_aliases[wofistyle]="$DOTS/wofi/style.css"
metro_aliases[dunst]="dunstrc"
metro_aliases[ff]="config.jsonc"
metro_aliases[pyre]="pyre"
metro_aliases[zsh]=".zshrc"
metro_aliases[gitig]=".gitignore"

_metro_find_config() {
    local target_file=$1
    fd --type f --hidden --absolute-path "^${target_file}$" "$DOTS" "$HOME/.local/bin" "$HOME" --max-depth 5 | head -n 1
}

_metro_resolve_path() {
    local input=$1
    local target_path

    if [[ -v "metro_aliases[$input]" ]]; then
        target_path=${metro_aliases[$input]}
    else
        target_path=$input
    fi

    if [[ "$target_path" == \/* || "$target_path" == \~* ]]; then
        echo "$target_path"
    else
        _metro_find_config "$target_path"
    fi
}

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
#          slay -  Find and kill processes by name
# =================================================================
#  IMPROVEMENT: The function is now safer. It first sends a graceful `SIGTERM`
#   signal. If that fails, it escalates to a forceful `SIGKILL`.
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
    echo "Sending SIGTERM to processes matching '$1'..."
    echo "$pids" | xargs kill >/dev/null 2>&1
    
    sleep 1
    pids=$(pgrep -fi "$1")

    if [ -n "$pids" ]; then
        echo "Processes still running. Sending SIGKILL..."
        echo "$pids" | xargs kill -9
        echo "Done."
    else
        echo "All processes terminated gracefully."
    fi
}

# =================================================================
#                 gstat - Git Status for all repos
# =================================================================
# Usage: gstat (run it in your main projects folder)
gstat() {
    command find . -maxdepth 2 -name ".git" -type d | while read -r gitdir; do
        # CORRECTED: Use a combined declaration and assignment syntax
        # to prevent the shell from printing debug output.
        local projectdir=$(dirname "$gitdir")
        
        echo ""
        echo "---   Status for: $projectdir ---"
        
        # CORRECTED: Same combined syntax for this variable
        local git_status=$(cd "$projectdir" && git status -s)
        
        if [ -z "$git_status" ]; then
            echo "   Clean"
        else
            echo "$git_status"
        fi
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
