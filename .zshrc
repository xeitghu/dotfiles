# ╔══════════════════════════════════════════════════════════════╗
# ║                                                              ║
# ║                  ~/.zshrc - REFINED CONFIG                   ║
# ║                                                              ║
# ╚══════════════════════════════════════════════════════════════╝

# ┌──────────────────────────────────────────────────┐
# │              1. Environment & Path               │
# └──────────────────────────────────────────────────┘
#  Using `typeset -U path` automatically removes duplicate entries for a clean PATH.
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.spicetify"
    "$HOME/.lmstudio/bin"
    $path
)
export PATH

#  Core environment variables for scripts and applications.
export ZSH="$HOME/.oh-my-zsh"
export DOTS="$HOME/.config"
export HYPR="$DOTS/hypr"

#  Set your default text editor.
export EDITOR='nvim'

# ┌──────────────────────────────────────────────────┐
# │              2. Zsh Core & Options               │
# └──────────────────────────────────────────────────┘
#  Set the desired Oh My Zsh theme.
export ZSH_THEME="powerlevel10k/powerlevel10k"

# --- History Settings ---
#  Configure history behavior for a large and persistent command history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# --- Zsh Options ---
#  Options for a better and more intuitive interactive experience.
setopt AUTO_CD              # Change directory without the `cd` command.
setopt NOTIFY               # Instantly notify on background job completion.
setopt SHARE_HISTORY        # Share history between all open terminals.
setopt EXTENDED_GLOB        # Enable extended globbing features (e.g., `^` for negation).
setopt HIST_IGNORE_DUPS     # Don't save consecutive duplicate commands.
setopt HIST_IGNORE_SPACE    # Don't save commands starting with a space.

#  Fix for slow shell startup by caching completions. This significantly improves launch time.
autoload -U compinit
local zcompfile="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -f "$zcompfile" ]] && (( $(date +%s -r "$zcompfile") < $(date +%s -d '-20 hours') )); then
    compinit -i
else
    compinit -C -i
fi

#  Set Oh My Zsh update mode to 'reminder' to avoid auto-updates.
zstyle ':omz:update' mode reminder

# ┌──────────────────────────────────────────────────┐
# │                     3. Plugins                   │
# └──────────────────────────────────────────────────┘
#  List of plugins for Oh My Zsh to load. Order can be important.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

# ┌──────────────────────────────────────────────────┐
# │             4. FZF Configuration                 │
# └──────────────────────────────────────────────────┘
#  Speed up FZF by using `fd` instead of the standard `find`.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'

#  Global settings for a beautiful and functional FZF with `bat` previews.
export FZF_DEFAULT_OPTS='
--height 40% --layout=reverse --border=rounded
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
--preview "bat --color=always --style=plain --line-range :500 {}"
--preview-window "right:55%:border-rounded"
'

# ┌──────────────────────────────────────────────────┐
# │                     5. Aliases                   │
# └──────────────────────────────────────────────────┘
# --- Package Management ---
alias update='yay -Syu'                 # Update all system packages
alias install='yay -S'                  # Install a new package
alias remove='sudo pacman -Rns'         # Remove a package with dependencies
alias search='yay -Ss'                  # Search for a package
alias clean='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "No orphans to remove."; yay -Yc'

# --- Utility Replacements ---
alias ls='eza --icons --group-directories-first'                         # Modern replacement for 'ls'
alias ll='eza -lh --icons --git --group-directories-first --header'      # Long list format
alias la='eza -lha --icons --git --group-directories-first --header'     # Long list format with hidden files
alias cat='bat --paging=never --style=plain'                             # Modern replacement for 'cat'
alias less='bat --paging=always'                                         # Use bat as a pager
alias lt='eza --tree --level=2 --icons'                                  # Tree view (2 levels deep)
alias ltf='eza --tree --level=10 --icons'                                # Full tree view
alias lsz='eza -lrh --sort=size --icons'                                 # Sort by size
alias ld='eza -lrh --sort=modified --icons'                              # Sort by date
alias find='fd'                                                          # Modern replacement for 'find'
alias grep='rg'                                                          # Modern replacement for 'grep'
alias top='btop'                                                         # Modern replacement for 'top'
alias df='duf'                                                           # Modern replacement for 'df'

# --- Navigation & Convenience ---
alias ..='cd ..'                        # Go up one directory
alias ...='cd ../..'                    # Go up two directories
alias c='clear'                         # Clear the terminal screen
alias h='history'                       # Show command history

# --- Quick Navigation ---
alias gohome='cd ~'                     # Go to home directory
alias goconf='cd $DOTS'                 # Go to config directory
alias gohypr='cd $HYPR'                 # Go to Hyprland config directory
alias gowaybar='cd $DOTS/waybar'        # Go to Waybar config directory
alias gowofi='cd $DOTS/wofi'            # Go to Wofi config directory
alias godunst='cd $DOTS/dunst'          # Go to Dunst config directory
alias gokitty='cd $DOTS/kitty'          # Go to Kitty config directory
alias goscripts='cd $HYPR/scripts'      # Go to Hyprland scripts directory

# --- Dotfiles Management ---
#  [INFO] Core wrapper function for the bare dotfiles repository.
#          All other 'd*' aliases depend on this.
dotgit() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

alias dstat='dotgit status'             # Show status of dotfiles repo
alias dadd='dotgit add'                 # Add files to dotfiles repo
alias ddel='dotgit rm'                  # Remove files from dotfiles repo
alias dsee='dotgit ls-files | eza --tree --icons' # View tracked dotfiles as a tree
alias dcomm='dotgit commit -m'          # Commit changes to dotfiles
alias dpush='dotgit push'               # Push dotfiles to remote
alias dlog='dotgit log --oneline --graph --decorate' # View dotfiles commit log
alias lg='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' # Open lazygit for dotfiles
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# --- TUI Applications ---
alias lzd='lazydocker'                  # Launch Lazydocker
alias lgit='lazygit'                    # Launch Lazygit
alias zj='zellij'                       # Launch Zellij
alias za='zellij attach'                # Attach to a Zellij session
alias zk='zellij kill-all-sessions'     # Kill all Zellij sessions

# --- Custom ---
alias vencord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'

# ┌──────────────────────────────────────────────────┐
# │                    6. Functions                  │
# └──────────────────────────────────────────────────┘
# =================================================================
#          dfind - Audit untracked configuration files
# =================================================================
dfind() {
    local untracked_files
    untracked_files=$(dotgit ls-files --others --exclude-standard -- ~/.config ~/.local/bin ~/.zshrc ~/.p10k.zsh)

    if [ -n "$untracked_files" ]; then
        echo "┌─  Untracked Dotfiles ───────────────────────────────────────────┐"
        echo "$untracked_files" | sed 's/^/│  /;$s/│/└/'
        echo "└────────────────────────────────────────────────────────────────┘"
        echo "  Use 'dadd <path>' to add them."
    else
        echo " All dotfiles are tracked."
    fi
}

# =================================================================
#          Metro System - Config file management system
# =================================================================
typeset -A metro_aliases
metro_aliases=(
    [hypr]="hyprland.conf"
    [binds]="keybinds.conf"
    [rules]="window_rules.conf"
    [look]="look.conf"
    [colors]="colors.conf"
    [pyrelayouts]="pyre_layouts.conf"
    [filemanager]="filemanager.conf"
    [kitty]="kitty.conf"
    [wb]="$DOTS/waybar/config"
    [wbs]="$DOTS/waybar/style.css"
    [waybarcolors]="$DOTS/waybar/colors.css"
    [wofi]="$DOTS/wofi/style.css"
    [wofistyle]="$DOTS/wofi/style.css"
    [dunst]="dunstrc"
    [ff]="config.jsonc"
    [pyre]="pyre"
    [zsh]=".zshrc"
    [gitig]="$HOME/.gitignore"
    [swww]="$HOME/.local/bin/wpr"
)

_metro_find_config() {
    fd --type f --hidden --absolute-path "^${1}$" "$DOTS" "$HOME/.local/bin" "$HOME" --max-depth 5 | head -n 1
}

_metro_resolve_path() {
    local input=$1
    local target_path=${metro_aliases[$input]:-$input}

    if [[ "$target_path" == \/* || "$target_path" == \~* ]]; then
        echo "$target_path"
    else
        _metro_find_config "$target_path"
    fi
}

edit() {
    # Handle direct argument calls first
    if [[ -n "$1" ]]; then
        if [[ "$1" == "p10k" ]]; then
            p10k configure
            return 0
        fi
        local found_path=$(_metro_resolve_path "$1")
        if [[ -n "$found_path" ]]; then
            $EDITOR "$found_path"
        else
            echo "Config not found: $1"
            return 1
        fi
        return 0
    fi

    # Interactive FZF menu if no arguments are given
    local aliases=$(for key in "${(@k)metro_aliases}"; do printf "%-15s -> %s\n" "$key" "$(basename "${metro_aliases[$key]}")"; done | sort)
    local functions_to_export=$(typeset -f _metro_find_config _metro_resolve_path)
    local selected_alias
    
    selected_alias=$(echo -e "p10k           -> Configure Powerlevel10k\n$aliases" | fzf \
        --header=" Select a config to edit" \
        --preview="$functions_to_export; \
            alias_to_preview=\$(echo {} | awk '{print \$1}'); \
            path_to_preview=\$(_metro_resolve_path \"\$alias_to_preview\"); \
            bat --color=always --style=plain \"\$path_to_preview\" 2>/dev/null || echo \"Cannot preview this file.\"")

    if [[ -n "$selected_alias" ]]; then
        edit "$(echo "$selected_alias" | awk '{print $1}')"
    fi
}

view() {
    if [[ -z "$1" ]]; then
        echo "Usage: view <alias_or_filename>"
        return 1
    fi
    
    local found_path=$(_metro_resolve_path "$1")
    if [[ -n "$found_path" ]]; then
        bat --paging=never "$found_path"
    else
        echo "Config not found: $1"
        return 1
    fi
}

# =================================================================
#          slay - Find and kill processes by name
# =================================================================
slay() {
    if [[ -z "$1" ]]; then
        echo "Usage: slay <process_name>"
        return 1
    fi

    local pids=$(pgrep -fi "$1")
    if [[ -z "$pids" ]]; then
        echo "No processes found matching '$1'."
        return 0
    fi

    echo "Found PIDs: $pids. Sending SIGTERM..."
    kill $pids >/dev/null 2>&1
    sleep 1
    
    # Check if processes are still running
    pids=$(pgrep -fi "$1")
    if [[ -n "$pids" ]]; then
        echo "Processes still running. Sending SIGKILL..."
        kill -9 $pids
    else
        echo "All processes terminated gracefully."
    fi
}

# =================================================================
#          gstat - Git status for all repos in current dir
# =================================================================
gstat() {
    command find . -maxdepth 2 -name ".git" -type d | while read -r gitdir; do
        local projectdir=$(dirname "$gitdir")
        echo "\n---  Status for: $projectdir ---"
        
        local git_status=$(cd "$projectdir" && git status -s)
        if [[ -z "$git_status" ]]; then
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
    if [[ ! -f "$1" ]]; then
        echo "'$1' is not a valid file"
        return 1
    fi

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
}

# =================================================================
#          tarc - Create a .tar.gz archive
# =================================================================
tarc() {
    if [[ -z "$1" ]]; then
        echo "Usage: tarc <archive_name> [files_to_compress...]"
        return 1
    fi
    local archive_name="$1.tar.gz"
    shift
    echo "Creating archive: $archive_name"
    tar -czvf "$archive_name" "$@"
}

# =================================================================
#          up - Go up multiple directory levels
# =================================================================
up() {
    if [[ -z "$1" ]]; then
        echo "Usage: up <levels>"
        return 1
    fi

    local target_dir="../"
    for i in {1..$(( $1 - 1 ))}; do
        target_dir="$target_dir../"
    done
    cd "$target_dir"
}

# =================================================================
#          serve - Start a simple web server
# =================================================================
serve() {
    echo "Serving current directory on http://localhost:8000"
    python -m http.server
}

# =================================================================
#          bak - Create a timestamped backup of a file
# =================================================================
bak() {
    if [[ -z "$1" ]]; then
        echo "Usage: bak <filename>"
        return 1
    fi
    cp -iv "$1" "$1.bak.$(date +'%Y%m%d-%H%M%S')"
}

# =================================================================
#          mkcd - Create a directory and enter it
# =================================================================
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ┌──────────────────────────────────────────────────┐
# │             7. Initialization & Startup          │
# └──────────────────────────────────────────────────┘
#  More robust initialization to prevent errors if a tool is not installed.

#  Load Zoxide if it exists
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

#  Load Atuin if it exists
command -v atuin >/dev/null && eval "$(atuin init zsh)"

#  Load Oh My Zsh framework
source $ZSH/oh-my-zsh.sh

#  Load Powerlevel10k theme configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

#  Load fzf key bindings and completions
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
