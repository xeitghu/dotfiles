# ┌────────────────────────────────────────────────────────────────────────────┐
# │                                5. Aliases                                  │
# └────────────────────────────────────────────────────────────────────────────┘

# --- 1. System & Maintenance --------------------------------------------------
# [INFO] Core system updates and package management
alias sudo='sudo '                                      # Enable aliases with sudo
alias c='clear'                                         # Clear terminal
alias h='history'                                       # Show history
alias update='~/.config/hypr/scripts/core/sysup.sh'     
alias menu='~/.config/hypr/scripts/core/sysmenu.sh'
alias install='yay -S'
alias remove='sudo pacman -Rns'
alias search='yay -Ss'

# --- 2. Filesystem & Navigation -----------------------------------------------
# [INFO] Modern replacements for standard tools (ls -> eza, cat -> bat, etc.)
alias ..='cd ..'
alias ...='cd ../..'
alias cdi='zi'                                          # Interactive zoxide jump

# Eza (ls replacement)
alias ls='eza --icons --group-directories-first --git'
alias ll='eza -lh --icons --git --group-directories-first --header'
alias la='eza -lha --icons --git --group-directories-first --header'
alias lt='eza --tree --level=2 --icons'
alias ltf='eza --tree --level=10 --icons'
alias lsz='eza -lrh --sort=size --icons'
alias ld='eza -lrh --sort=modified --icons'

# Content Viewers
alias cat='bat --paging=never --style=plain'
alias less='bat --paging=always'

# File Operations
alias cp='cp -iv'                                       # Interactive copy
alias mv='mv -iv'                                       # Interactive move
alias rm='rip'                                          # Safe delete
alias rml='rip -s'                                      # List deleted (Seance)
alias rmu='rip -u'                                      # Restore last (Unbury)
alias rmd='rip -d'                                      # Empty trash (Decompose)
alias rmr='rip -s | fzf | xargs -I{} rip -u "{}"'       # Restore via FZF
alias rmdir='rm'
alias x='ouch decompress'                               # Smart extract
alias pack='ouch compress'                              # Smart compress
alias o='xdg-open'

# Search & Info
alias find='fd'
alias grep='rg'
alias ncdu='gdu'                                        # Modern replacement for ncdu
alias df='duf'

# --- 3. Git & Dotfiles --------------------------------------------------------
# [INFO] Shortcuts for version control and config management
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias lgit='lazygit'

# Dotfiles (requires 'dotgit' function in 06_functions.zsh)
alias dstat='dotgit status'
alias dls='dotgit ls-files | eza --tree --icons'
alias dadd='dotgit add'
alias dpush='dotgit push'
alias ddel='dotgit rm'
alias dgcm='dotgit commit -m'
alias dgc='dotgit commit'
alias ddf='dotgit diff'
alias dlog='dotgit log --oneline --graph --decorate'
alias lg='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# --- 4. Applications & TUI ----------------------------------------------------
# [INFO] Terminal User Interfaces and Apps
alias top='btop'
alias lzd='lazydocker'
alias sampler="sampler --config ~/.config/sampler/sampler.yml"
alias aideupd='sudo aide-update'
alias ping='gping'

# Zellij (Terminal Multiplexer)
alias zj='zellij'
alias za='zellij attach'
alias zk='zellij kill-all-sessions'

# ttyper (Terminal-based typing test)
alias tt='ttyper'                                                         # En
alias ttru='ttyper --language-file ~/.config/ttyper/languages/russian'    # Ru
alias ttpy='ttyper -l python'                                             # Python

# --- 5. Hardware & Services ---------------------------------------------------
# [INFO] Audio, Brightness, and System Services
alias soundreload='systemctl --user restart pipewire.service pipewire-pulse.service wireplumber.service'
alias st="systemctl --user enable --now syncthing"

# Brightness Manager
_BR_LOCK="${XDG_RUNTIME_DIR:-/tmp}/brightness_disabled"

alias bon='rm -f "$_BR_LOCK" && echo "🌞 Auto brightness re-enabled."'
alias boff='touch "$_BR_LOCK" && echo "🌙 Auto brightness disabled."'
alias breset='~/.local/bin/brightness-manager --force'
alias blog='journalctl --user -u brightness-manager -n 20 --no-pager'

# --- 6. Installers & Scripts --------------------------------------------------
# [INFO] One-off commands for third-party tools
alias vencord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'
alias spiceinstall='curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh'
alias spicefix='spicetify backup apply'
