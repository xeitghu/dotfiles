# ┌──────────────────────────────────────────────────┐
# │               ZSH - MAIN CONFIGURATION           │
# └──────────────────────────────────────────────────┘

# ┌──────────────────────────────────────────────────┐
# │              1. Environment & Path               │
# └──────────────────────────────────────────────────┘
# [INFO] Using 'typeset -U path' automatically removes duplicate entries for a clean PATH.
typeset -U path
path=(
    "$HOME/.local/bin"
    "$HOME/.spicetify"
    "$HOME/.lmstudio/bin"
    $path
)
export PATH

# [INFO] Core environment variables for scripts and applications.
export ZSH="$HOME/.oh-my-zsh"
export DOTS="$HOME/.config"
export HYPR="$DOTS/hypr"

# [CONFIG] Set your default text editor.
export EDITOR='nvim'

# ┌──────────────────────────────────────────────────┐
# │              2. Zsh Core & Options               │
# └──────────────────────────────────────────────────┘
# [CONFIG] Set the desired Oh My Zsh theme.
export ZSH_THEME="powerlevel10k/powerlevel10k"

# --- History Settings ---
# [CONFIG] Configure history behavior for a large and persistent command history.
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

# --- Zsh Options ---
# [INFO] Options for a better and more intuitive interactive experience.
setopt AUTO_CD              # Change directory without the 'cd' command.
setopt NOTIFY               # Instantly notify on background job completion.
setopt SHARE_HISTORY        # Share history between all open terminals.
setopt EXTENDED_GLOB        # Enable extended globbing features (e.g., '^' for negation).
setopt HIST_IGNORE_DUPS     # Don't save consecutive duplicate commands.
setopt HIST_IGNORE_SPACE    # Don't save commands starting with a space.

# [FIX] Fix for slow shell startup by caching completions.
autoload -U compinit
zcompfile="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -f "$zcompfile" ]] && (( $(date +%s -r "$zcompfile") < $(date +%s -d '-20 hours') )); then
    compinit -i
else
    compinit -C -i
fi

# [INFO] Set Oh My Zsh update mode to 'reminder' to avoid auto-updates.
zstyle ':omz:update' mode reminder

# ┌──────────────────────────────────────────────────┐
# │                     3. Plugins                   │
# └──────────────────────────────────────────────────┘
# [INFO] List of plugins for Oh My Zsh to load.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

# ┌──────────────────────────────────────────────────┐
# │             4. FZF Configuration                 │
# └──────────────────────────────────────────────────┘
# [INFO] Speed up FZF by using 'fd' instead of the standard 'find'.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix --exclude .git'

# [CONFIG] Global settings for a beautiful and functional FZF with 'bat' previews.
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

# --- Utility Replacements ---
alias ls='eza --icons --group-directories-first'          # Modern replacement for 'ls'
alias ll='eza -lh --icons --git --group-directories-first --header' # Long list format
alias la='eza -lha --icons --git --group-directories-first --header' # Long list format with hidden files
alias cat='bat --paging=never --style=plain'              # Modern replacement for 'cat'
alias less='bat --paging=always'                          # Use bat as a pager
alias lt='eza --tree --level=2 --icons'                   # Tree view (2 levels deep)
alias ltf='eza --tree --level=10 --icons'                 # Full tree view
alias lsz='eza -lrh --sort=size --icons'                  # Sort by size
alias ld='eza -lrh --sort=modified --icons'               # Sort by date
alias find='fd'                                           # Modern replacement for 'find'
alias grep='rg'                                           # Modern replacement for 'grep'
alias top='btop'                                          # Modern replacement for 'top'
alias df='duf'                                            # Modern replacement for 'df'

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
alias soundreload='systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service'

# ┌──────────────────────────────────────────────────┐
# │                    6. Functions                  │
# └──────────────────────────────────────────────────┘

# --- dfind - Audit untracked configuration files ---
dfind() {
    local untracked_files
    untracked_files=$(dotgit ls-files --others --exclude-standard -- ~/.config ~/.local/bin ~/.zshrc ~/.p10k.zsh)

    if [ -n "$untracked_files" ]; then
        echo "┌─ [CRITICAL] Untracked Dotfiles ──────────────────────────────────┐"
        echo "$untracked_files" | sed 's/^/│  /;$s/│/└/'
        echo "└────────────────────────────────────────────────────────────────┘"
        echo "  Use 'dadd <path>' to add them."
    else
        echo "All dotfiles are tracked."
    fi
}

# --- Metro System - Config file management ---
typeset -A metro_aliases
metro_aliases=(
    # --- Hyprland & Components ---
    [hypr]="$HYPR/hyprland.conf"
    [binds]="$HYPR/keybinds.conf"
    [rules]="$HYPR/window_rules.conf"
    [look]="$HYPR/look.conf"
    [theme]="$HYPR/theme.conf"

    # --- Applications ---
    [kitty]="$DOTS/kitty/kitty.conf"
    [dunst]="$DOTS/dunst/dunstrc"
    [fastfetch]="$DOTS/fastfetch/config.jsonc"

    # --- Waybar ---
    [waybar]="$DOTS/waybar/config.jsonc"
    [waybarstyle]="$DOTS/waybar/style.css"
    [waybarcolors]="$DOTS/waybar/colors.css"

    # --- Wofi ---
    [wofi]="$DOTS/wofi/config"
    [wofistyle]="$DOTS/wofi/style.css"

    # --- Scripts & Shell ---
    [pyre]="$HOME/.local/bin/pyre"
    [wpr]="$HOME/.local/bin/wpr"
    [zsh]="$HOME/.zshrc"
    [gitig]="$HOME/.gitignore"
)
_metro_find_config() {
    fd --type f --hidden --absolute-path "^${1}$" "$DOTS" "$HOME/.local/bin" "$HOME" --max-depth 5 | head -n 1
}
_metro_resolve_path() {
    local input=$1
    local target_path=${metro_aliases[$input]:-$input}

    if [[ "$target_path" == /* || "$target_path" == ~* ]]; then
        echo "$target_path"
    else
        _metro_find_config "$target_path"
    fi
}
edit() {
    # [INFO] Handle direct argument calls first.
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

    # [INFO] Interactive FZF menu if no arguments are given.
    local aliases=$(for key in "${(@k)metro_aliases}"; do printf "%-15s -> %s\n" "$key" "$(basename "${metro_aliases[$key]}")"; done | sort)
    local data_to_pass="$(typeset -p metro_aliases); $(typeset -f _metro_find_config _metro_resolve_path)"
    local selected_alias
    
    selected_alias=$(echo -e "p10k           -> Configure Powerlevel10k\n$aliases" | fzf \
        --header="Select a config to edit" \
        --preview="$data_to_pass; \
                   alias_to_preview=\$(echo {} | awk '{print \$1}'); \
                   path_to_preview=\$(_metro_resolve_path \"\$alias_to_preview\"); \
                   bat --color=always --style=plain --line-range :500 \"\$path_to_preview\" 2>/dev/null || echo \"File not found or cannot be previewed.\"")

    if [[ -n "$selected_alias" ]]; then
        edit "$(echo "$selected_alias" | awk '{print $1}')"
    fi
}
view() {
    # [INFO] Default viewer is 'bat' with its full features.
    local viewer_command="bat --paging=never"
    local target_alias="$1"

    # [INFO] Check for the '-c' flag to switch to 'clean' mode.
    if [[ "$1" == "-c" ]]; then
        # [INFO] The 'cat' command will use your alias: 'bat --style=plain'
        viewer_command="cat"
        shift # Removes '-c' from arguments, so $1 is now the alias.
        target_alias="$1"
    fi

    # [INFO] Show usage if no file/alias is provided.
    if [[ -z "$target_alias" ]]; then
        echo "Usage: view [-c] <alias_or_filename>"
        echo "  -c: Use clean view (like 'cat', without line numbers)"
        return 1
    fi
    
    local found_path=$(_metro_resolve_path "$target_alias")
    if [[ -n "$found_path" ]]; then
        # [INFO] We use 'eval' here to correctly process the command string with its arguments.
        eval "$viewer_command \"$found_path\""
    else
        echo "Config not found: $target_alias"
        return 1
    fi
}

# --- slay - Find and kill processes interactively ---
slay() {
    # [INFO] If no argument is given, show all processes in FZF for selection.
    if [[ -z "$1" ]]; then
        local pid_to_kill
        # [INFO] Select PID from an interactive FZF list.
        pid_to_kill=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [[ -n "$pid_to_kill" ]]; then
            # [INFO] Use xargs to pass all selected PIDs to kill.
            echo "$pid_to_kill" | xargs kill -9
            echo "Process(es) terminated."
        fi
        return 0
    fi

    # [INFO] Original logic for searching by name if an argument is provided.
    local pids
    pids=$(pgrep -fi "$1")
    [[ -z "$pids" ]] && { echo "No processes found matching '$1'."; return 0; }
    
    echo "Found PIDs for '$1': $pids"
    ps -fp "$pids"
    read -r "ans?Kill these processes? [y/N] "
    if [[ $ans == [yY] ]]; then
        kill "$pids" >/dev/null 2>&1 && sleep 0.5
        if pgrep -fi "$1" >/dev/null; then
            echo "Processes still running. Sending SIGKILL..."
            kill -9 "$pids"
        else
            echo "Processes terminated."
        fi
    else
        echo "Aborted."
    fi
}

# --- copy - Copy piped input to the system clipboard ---
copy() {
    # [INFO] 1. Wayland check
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy
    # [INFO] 2. X11 check
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    # [INFO] 3. X11 alternative
    elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --input
    # [INFO] 4. Fallback for WSL
    elif command -v clip.exe >/dev/null 2>&1; then
        clip.exe
    else
        echo "Error: Clipboard tool not found. Please install 'xclip' (Xorg) or 'wl-clipboard' (Wayland)." >&2
        return 1
    fi
}

# --- gstat - Git status for all repos in current dir ---
gstat() {
    command find . -maxdepth 2 -name ".git" -type d | while read -r gitdir; do
        local projectdir=$(dirname "$gitdir")
        echo "\n--- Status for: $projectdir ---"
        
        local git_status=$(cd "$projectdir" && git status -s)
        if [[ -z "$git_status" ]]; then
            echo "  Clean"
        else
            echo "$git_status"
        fi
    done
}

# --- clean - Safely remove orphan packages and clean cache ---
clean() {
    local orphans
    orphans=$(pacman -Qtdq)
    if [ -n "$orphans" ]; then
        echo "[INFO] The following orphan packages will be removed:"
        echo "$orphans" | nl
        read -r "ans?Proceed? (y/N) "
        if [[ "$ans" == [yY] ]]; then
            sudo pacman -Rns "$orphans"
        else
            echo "Aborted."
        fi
    else
        echo "No orphan packages to remove."
    fi
    # [INFO] Run yay cache cleanup regardless.
    yay -Yc
}

# --- extract - Decompress any archive ---
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

# --- tarc - Create a .tar.gz archive ---
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

# --- up - Go up multiple directory levels ---
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

# --- serve - Start a simple web server ---
serve() {
    echo "Serving current directory on http://localhost:8000"
    python -m http.server
}

# --- bak - Create a timestamped backup of a file ---
bak() {
    if [[ -z "$1" ]]; then
        echo "Usage: bak <filename>"
        return 1
    fi
    cp -iv "$1" "$1.bak.$(date +'%Y%m%d-%H%M%S')"
}

# --- mkcd - Create a directory and enter it ---
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ┌──────────────────────────────────────────────────┐
# │             7. Initialization & Startup          │
# └──────────────────────────────────────────────────┘
# [INFO] Robust initialization to prevent errors if a tool is not installed.

# --- Load Shell Integrations ---
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v atuin >/dev/null && eval "$(atuin init zsh)"

# --- Load Frameworks & Themes ---
source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- Load FZF ---
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
