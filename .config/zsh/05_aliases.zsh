# ┌────────────────────────────────────────────────────────────────────────────┐
# │                                5. Aliases                                  │
# └────────────────────────────────────────────────────────────────────────────┘

# --- Package Management ---
alias update='sudo ~/.config/hypr/scripts/core/system_update.sh'        # Update all system packages
alias install='yay -S'                                                  # Install a new package
alias remove='sudo pacman -Rns'                                         # Remove a package with dependencies
alias search='yay -Ss'                                                  # Search for a package

# --- Security & Integrity ---
alias aideupd='sudo aide-update'

# --- Utility Replacements ---
alias ls='eza --icons --group-directories-first'                        # Modern replacement for 'ls'
alias ll='eza -lh --icons --git --group-directories-first --header'     # Long list format
alias la='eza -lha --icons --git --group-directories-first --header'    # Long list format with hidden files
alias cat='bat --paging=never --style=plain'                            # Modern replacement for 'cat'
alias less='bat --paging=always'                                        # Use bat as a pager
alias lt='eza --tree --level=2 --icons'                                 # Tree view (2 levels deep)
alias ltf='eza --tree --level=10 --icons'                               # Full tree view
alias lsz='eza -lrh --sort=size --icons'                                # Sort by size
alias ld='eza -lrh --sort=modified --icons'                             # Sort by date
alias find='fd'                                                         # Modern replacement for 'find'
alias grep='rg'                                                         # Modern replacement for 'grep'
alias top='btop'                                                        # Modern replacement for 'top'
alias df='duf'                                                          # Modern replacement for 'df'

# --- Navigation & Convenience ---
alias ..='cd ..'                                                        # Go up one directory
alias ...='cd ../..'                                                    # Go up two directories
alias c='clear'                                                         # Clear the terminal screen
alias h='history'                                                       # Show command history

# --- Quick Navigation ---
alias gohome='cd ~'                                                                     # Go to home directory
alias goconf='cd $DOTS'                                                                 # Go to config directory
alias gohypr='cd $HYPR'                                                                 # Go to Hyprland config directory
alias gowaybar='cd $DOTS/waybar'                                                        # Go to Waybar config directory
alias gowofi='cd $DOTS/wofi'                                                            # Go to Wofi config directory
alias godunst='cd $DOTS/dunst'                                                          # Go to Dunst config directory
alias gokitty='cd $DOTS/kitty'                                                          # Go to Kitty config directory
alias goscripts='cd $HYPR/scripts'                                                      # Go to Hyprland scripts directory
alias goeg='cd "$HOME/Documents/Vaults/Obsidian Vault/prompt-engineering/Evergreen"'    # Go to Evergreen directory

# --- Dotfiles Management ---
dotgit() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
alias dstat='dotgit status'                                                 # Show status of dotfiles repo
alias dadd='dotgit add'                                                     # Add files to dotfiles repo
alias ddel='dotgit rm'                                                      # Remove files from dotfiles repo
alias dsee='dotgit ls-files | eza --tree --icons'                           # View tracked dotfiles as a tree
alias dgcm='dotgit commit -m'                                               # Commit changes to all dotfiles
alias dgc='dotgit commit'                                                   # Commit changes to dotfiles   
alias dpush='dotgit push'                                                   # Push dotfiles to remote
alias dlog='dotgit log --oneline --graph --decorate'                        # View dotfiles commit log
alias lg='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'             # Open lazygit for dotfiles
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# --- TUI Applications ---
alias lzd='lazydocker'                                                      # Launch Lazydocker
alias lgit='lazygit'                                                        # Launch Lazygit
alias zj='zellij'                                                           # Launch Zellij
alias za='zellij attach'                                                    # Attach to a Zellij session
alias zk='zellij kill-all-sessions'                                         # Kill all Zellij sessions

# --- Brightness control helpers ---
alias brighton='rm -f /tmp/auto_brightness_disabled && echo "🌞 Auto brightness re-enabled."'
alias brightoff='touch /tmp/auto_brightness_disabled && echo "🌙 Auto brightness disabled."'
alias brightlog='bat --style=plain ~/.cache/brightness-manager.log | tail -n 20'

# --- Custom ---
alias vencord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'
alias soundreload='systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service'
alias spiceinstall='curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh'
alias spicefix='spicetify backup apply'
alias sampler="sampler --config ~/.config/sampler/sampler.yml"
alias st="systemctl --user enable --now syncthing"
