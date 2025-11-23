# ┌────────────────────────────────────────────────────────────────────────────┐
# │                                6. Functions                                │
# └────────────────────────────────────────────────────────────────────────────┘

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                        Metro System - Config Maps                          │
# └────────────────────────────────────────────────────────────────────────────┘

# [INFO] This system separates simple file aliases from complex modules.

# --- Part 1: Direct links to single configuration files ---
# [CONFIG] Map of aliases to individual files.
typeset -A metro_files
metro_files=(
    # --- Hyprland Module Shortcuts ---
    [hyprconf]="$HYPR/hyprland.conf"    # Main config
    [binds]="$HYPR/keybinds.conf"       # Keybindings
    [rules]="$HYPR/rules.conf"          # Window rules
    [look]="$HYPR/look.conf"            # GTK, fonts, etc.
    [theme]="$HYPR/theme.conf"          # Theming variables
    [lock]="$HYPR/hyprlock.conf"        # Lock screen config

    # --- Zsh Ecosystem ---
    [zshenv]="$ZSH_CONFIG_DIR/01_environment.zsh"
    [zshopts]="$ZSH_CONFIG_DIR/02_options.zsh"
    [zshplugs]="$ZSH_CONFIG_DIR/03_plugins.zsh"
    [zshfzf]="$ZSH_CONFIG_DIR/04_fzf.zsh"
    [zshals]="$ZSH_CONFIG_DIR/05_aliases.zsh"
    [zshfn]="$ZSH_CONFIG_DIR/06_functions.zsh"
    [zshinit]="$ZSH_CONFIG_DIR/07_init.zsh"

    # --- Waybar Module Shortcuts ---
    [waybarconf]="$DOTS/waybar/config"
    [waybarstyle]="$DOTS/waybar/style.css"

    # --- Wofi Module Shortcuts ---
    [woficonf]="$DOTS/wofi/config"
    [wofistyle]="$DOTS/wofi/style.css"
    
    # --- Kitty Module Shortcuts ---
    [kittyconf]="$DOTS/kitty/kitty.conf"

    # --- Pyre Custom Engine ---
    [pyre]="$HOME/.local/bin/pyre"
    [pyrefn]="$HOME/.config/pyre/functions.sh"

    # --- Standalone Applications ---
    [cava]="$DOTS/cava/config"
    [dunst]="$DOTS/dunst/dunstrc"
    [fastfetch]="$DOTS/fastfetch/config.jsonc"
    [gammastep]="$DOTS/gammastep/config.ini"
    [sampler]="$DOTS/sampler/sampler.yml"
    [imv]="$DOTS/imv/config"
    [nvim]="$DOTS/nvim/lua/config/lazy.lua"
    [brightness]="$HOME/.local/bin/brightness-manager"
    [keyd]="/etc/keyd/default.conf"

    # --- Shell & Git ---
    [gitig]="$HOME/.gitignore"

    # --- Custom ---
    [ryzen]="/usr/local/sbin/apply-ryzen-settings.sh"
)

# --- Part 2: Links to modular configuration directories ---
# [CONFIG] Map of aliases to directories for full module browsing.
typeset -A metro_modules
metro_modules=(
    [hypr]="$HYPR"
    [kitty]="$DOTS/kitty"
    [waybar]="$DOTS/waybar"
    [wofi]="$DOTS/wofi"
    [zsh]="$ZSH_CONFIG_DIR"
)

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                        Metro System - Core Functions                       │
# └────────────────────────────────────────────────────────────────────────────┘

# --- _edit_resolve_path_for_preview - Helper for FZF preview ---
# [INFO] A dedicated helper to find a path for the previewer.
_edit_resolve_path_for_preview() {
    local alias="$1"
    if [[ -v metro_files[$alias] ]]; then
        echo "${metro_files[$alias]}"
    elif [[ -v metro_modules[$alias] ]]; then
        echo "${metro_modules[$alias]}"
    fi
}

# --- _edit_module - FZF sub-menu for a configuration module ---
# [INFO] This helper function is called by 'edit' for module directories.
# [EXAMPLE] _edit_module ~/.config/hypr
_edit_module() {
    local module_path="$1"
    local selected_file

    # [INFO] Use 'fd' to find all files within the module path, then pipe to fzf.
    selected_file=$(fd --type f . "$module_path" | fzf \
        --header="Editing Module: $(basename "$module_path") — Select a file" \
        --preview="bat --color=always --style=numbers --line-range :200 {}")

    # [INFO] If a file was selected, open it in the editor.
    if [[ -n "$selected_file" ]]; then
        $EDITOR "$selected_file"
    fi
}

# --- edit - The ultimate config file editor ---
# [INFO] Intelligently edits single files or entire configuration modules.
# [EXAMPLE] edit           # Opens the main interactive menu.
# [EXAMPLE] edit cava      # Opens the cava config file directly.
# [EXAMPLE] edit hypr      # Opens an FZF sub-menu for the hypr module.
edit() {
    # [INFO] Handle direct argument calls first.
    if [[ -n "$1" ]]; then
        local target_alias="$1"
        if [[ "$target_alias" == "p10k" ]]; then p10k configure; return 0; fi

        if [[ -v metro_files[$target_alias] ]]; then
            $EDITOR "${metro_files[$target_alias]}"
        elif [[ -v metro_modules[$target_alias] ]]; then
            _edit_module "${metro_modules[$target_alias]}"
        else
            echo "Config not found: $target_alias"
            return 1
        fi
        return 0
    fi

    # --- Interactive FZF Menu ---
    local file_list=$(for key in "${(@k)metro_files}"; do printf "%-15s [File]   -> %s\n" "$key" "$(basename "${metro_files[$key]}")"; done | sort)
    local module_list=$(for key in "${(@k)metro_modules}"; do printf "%-15s [Module] -> %s/\n" "$key" "$(basename "${metro_modules[$key]}")"; done | sort)
    local full_list="p10k           [Action] -> Configure Powerlevel10k\n${file_list}\n${module_list}"
    
    # [FIX] Use 'typeset -f' which is the correct way to export functions in Zsh.
    local data_to_pass="$(typeset -p metro_files metro_modules); $(typeset -f _edit_resolve_path_for_preview)"
    local selected_item

    selected_item=$(echo -e "$full_list" | fzf \
        --header="Select a config file or module to edit" \
        --preview="$data_to_pass; \
            alias_to_preview=\$(echo {} | awk '{print \$1}'); \
            path_to_preview=\$(_edit_resolve_path_for_preview \"\$alias_to_preview\"); \
            if [[ -f \"\$path_to_preview\" ]]; then \
                bat --color=always --style=numbers --line-range :200 \"\$path_to_preview\"; \
            elif [[ -d \"\$path_to_preview\" ]]; then \
                eza --tree --level=2 --icons \"\$path_to_preview\"; \
            fi" \
        --preview-window="right:55%:border-rounded")

    if [[ -n "$selected_item" ]]; then
        edit "$(echo "$selected_item" | awk '{print $1}')"
    fi
}

# --- view - Preview config files or modules ---
# [INFO] Intelligently previews single files or entire configuration modules.
# [EXAMPLE] view           # Opens the main interactive menu.
# [EXAMPLE] view cava      # Shows the contents of the cava config file.
# [EXAMPLE] view zsh       # Shows a tree view of the zsh module directory.
view() {
    # [INFO] Handle direct argument calls first.
    if [[ -n "$1" ]]; then
        local viewer_command="bat --paging=never"
        local target_alias="$1"

        if [[ "$1" == "-c" ]]; then
            viewer_command="cat" # Uses your 'cat' alias for plain view
            shift
            target_alias="$1"
        fi

        if [[ -v metro_files[$target_alias] ]]; then
            # [INFO] It's a file. Use the selected viewer.
            eval "$viewer_command \"${metro_files[$target_alias]}\""
        elif [[ -v metro_modules[$target_alias] ]]; then
            # [INFO] It's a module. A tree view is most useful here.
            eza --tree --level=3 --icons "${metro_modules[$target_alias]}"
        else
            echo "Config not found: $target_alias"
            return 1
        fi
        return 0
    fi

    # --- Interactive FZF Menu ---
    local file_list=$(for key in "${(@k)metro_files}"; do printf "%-15s [File]   -> %s\n" "$key" "$(basename "${metro_files[$key]}")"; done | sort)
    local module_list=$(for key in "${(@k)metro_modules}"; do printf "%-15s [Module] -> %s/\n" "$key" "$(basename "${metro_modules[$key]}")"; done | sort)
    local full_list="p10k           [Action] -> Configure Powerlevel10k\n${file_list}\n${module_list}"
    
    local data_to_pass="$(typeset -p metro_files metro_modules); $(typeset -f _edit_resolve_path_for_preview)"
    local selected_item

    # [INFO] The FZF command here is identical to the one in 'edit' for consistency.
    selected_item=$(echo -e "$full_list" | fzf \
        --header="Select a config to view" \
        --preview="$data_to_pass; \
            alias_to_preview=\$(echo {} | awk '{print \$1}'); \
            path_to_preview=\$(_edit_resolve_path_for_preview \"\$alias_to_preview\"); \
            if [[ -f \"\$path_to_preview\" ]]; then \
                bat --color=always --style=numbers --line-range :200 \"\$path_to_preview\"; \
            elif [[ -d \"\$path_to_preview\" ]]; then \
                eza --tree --level=2 --icons \"\$path_to_preview\"; \
            fi" \
        --preview-window="right:55%:border-rounded")

    # [INFO] If a selection was made, call 'view' again with the chosen alias.
    if [[ -n "$selected_item" ]]; then
        view "$(echo "$selected_item" | awk '{print $1}')"
    fi
}

# ┌────────────────────────────────────────────────────────────────────────────┐
# │                             Magic Enter                                    │
# └────────────────────────────────────────────────────────────────────────────┘
magic-enter() {
    if [[ -z "${BUFFER// }" ]]; then
        local cmd=" ls"
        
        if git status -s &>/dev/null; then
            cmd="$cmd && git status -sb"
        fi
        
        BUFFER="$cmd"
        zle accept-line
    else
        zle accept-line
    fi
}

zle -N magic-enter

# --- g - Your personal Git helper ---
g() {
    # If no arguments are provided, show the custom helper.
    if [ "$#" -eq 0 ]; then
        # --- Color Definitions ---
        C_RESET='\033[0m'
        C_BOLD='\033[1m'
        C_CYAN='\033[0;36m'
        C_GREEN='\033[0;32m'
        C_YELLOW='\033[0;33m'
        C_MAUVE='\033[0;35m' # A purple-ish color for titles

        echo -e "${C_BOLD}${C_MAUVE}┌──────────────────────────────────────────────────┐${C_RESET}"
        echo -e "${C_BOLD}${C_MAUVE}│            Your Personal Git Helper              │${C_RESET}"
        echo -e "${C_BOLD}${C_MAUVE}└──────────────────────────────────────────────────┘${C_RESET}"

        echo -e "\n${C_BOLD}${C_YELLOW}:: Dotfiles Management (d* aliases) ::${C_RESET}"
        echo -e " ${C_CYAN}dstat${C_RESET}\t\t         Show status of your dotfiles repo"
        echo -e " ${C_CYAN}dadd <file>${C_RESET}\t         Add a file to dotfiles tracking"
        echo -e " ${C_CYAN}dgcm \"...\"${C_RESET}\t\t Commit all staged dotfiles with a message"
        echo -e " ${C_CYAN}dpush${C_RESET}\t\t         Push dotfiles changes to remote"
        echo -e " ${C_CYAN}dlog${C_RESET}\t\t         View dotfiles commit history"
        echo -e " ${C_CYAN}lg${C_RESET}\t\t         Open Lazygit for dotfiles (interactive)"

        echo -e "\n${C_BOLD}${C_YELLOW}:: Standard Git Workflow (g <command>) ::${C_RESET}"
        echo -e " ${C_GREEN}g add <file>${C_RESET}\t         Stage a file for commit"
        echo -e " ${C_GREEN}g commit -m \"...\"${C_RESET}       Commit staged files"
        echo -e " ${C_GREEN}g push${C_RESET}\t\t         Push commits to the remote branch"
        echo -e " ${C_GREEN}g pull${C_RESET}\t\t         Fetch and merge changes from remote"
        echo -e " ${C_GREEN}g status${C_RESET}\t\t Check the current repository status"
        echo -e " ${C_GREEN}g log${C_RESET}\t\t         View commit history"
        echo -e " ${C_GREEN}glog${C_RESET}\t\t         View pretty, graphical commit history"
        echo -e " ${C_GREEN}lgit${C_RESET}\t\t         Open Lazygit for the current repo"

        echo -e "\n${C_BOLD}[TIP]${C_RESET} Use ${C_CYAN}lg${C_RESET} for dotfiles and ${C_GREEN}lgit${C_RESET} for everything else to simplify your workflow."
        return 0
    fi

    # If arguments are present, pass them to the actual git command.
    command git "$@"
}

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

# --- rgo - Search for a pattern across the entire project ---
rgo() {
    local editor=${2:-${EDITOR:-nvim}}
    local selection
    
    selection=$(rg --line-number --no-heading "$1" | fzf \
        --height=50% \
        --border=rounded \
        --delimiter=':' \
        --header="🔍 Project Search: $1 — Enter → open, ESC → cancel" \
        --preview-window="right:60%:wrap:border-rounded:follow" \
        --preview="bash -c ' \
            file_path=\"{1}\"; \
            line_num=\"{2}\"; \
            [[ -f \"\$file_path\" ]] && bat --paging=never --style=numbers --color=always --highlight-line \"\$line_num\" \"\$file_path\" \
        '")

    [[ -z "$selection" ]] && return 0

    local file=$(echo "$selection" | cut -d: -f1)
    local line=$(echo "$selection" | cut -d: -f2)

    "$editor" +"$line" "$file"
}

# --- fpeek - Interactively fuzzy-search within a single file ---
fpeek() {
    if [[ -z "$1" ]]; then
        echo "Usage: fpeek <filename>"
        echo "  Opens an fzf-powered view for interactive fuzzy-searching within a file."
        return 1
    fi

    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Error: File not found: $file"
        return 1
    fi

    local selection
    
    selection=$(rg --no-heading --line-number --color=always -i "" "$file" | fzf \
        --ansi \
        --delimiter=: \
        --header="🔍 $file — Fuzzy-search, Enter → open, ESC → cancel" \
        --height=30% \
        --layout=reverse \
        --border=rounded \
        --preview-window="right:50%:wrap:border-rounded:follow" \
        --preview="bash -c ' \
            file_path=\"\$1\"; \
            line_num=\"{1}\"; \
            start=\$(( line_num > 10 ? line_num - 10 : 1 )); \
            end=\$(( line_num + 10 )); \
            bat --paging=never --style=numbers --color=always --highlight-line \"\$line_num\" \"\$file_path\" --line-range \"\$start:\$end\" \
        ' bash \"$file\"")

    if [[ $? -ne 0 || -z "$selection" ]]; then
        return 0
    fi

    local line=$(echo "$selection" | awk -F: '{print $1}' | head -n1)

    ${EDITOR:-nvim} +"$line" "$file"
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

edit_pyre() {
    nvim -o "$HOME/.local/bin/pyre" "$HOME/.config/pyre/functions.sh"
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
