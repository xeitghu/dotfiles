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
alias rm='rm -iv'                                       # Interactive remove
alias x='ouch decompress'                               # Smart extract
alias pack='ouch compress'                              # Smart compress
alias o='xdg-open'

# Search & Info
alias find='fd'
alias grep='rg'
alias df='duf'

# --- 3. Git & Dotfiles --------------------------------------------------------
# [INFO] Shortcuts for version control and config management
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias lgit='lazygit'

# Dotfiles (requires 'dotgit' function in 06_functions.zsh)
alias dstat='dotgit status'
alias dadd='dotgit add'
alias ddel='dotgit rm'
alias dls='dotgit ls-files | eza --tree --icons'
alias dgcm='dotgit commit -m'
alias dgc='dotgit commit'
alias dpush='dotgit push'
alias dlog='dotgit log --oneline --graph --decorate'
alias lg='lazygit --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# --- 4. Applications & TUI ----------------------------------------------------
# [INFO] Terminal User Interfaces and Apps
alias top='btop'
alias lzd='lazydocker'
alias sampler="sampler --config ~/.config/sampler/sampler.yml"
alias aideupd='sudo aide-update'

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
alias brighton='rm -f /tmp/auto_brightness_disabled && echo "🌞 Auto brightness re-enabled."'
alias brightoff='touch /tmp/auto_brightness_disabled && echo "🌙 Auto brightness disabled."'
alias brightlog='bat --style=plain ~/.cache/brightness-manager.log | tail -n 20'

# --- 6. Installers & Scripts --------------------------------------------------
# [INFO] One-off commands for third-party tools
alias vencord='sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'
alias spiceinstall='curl -fsSL https://raw.githubusercontent.com/spicetify/spicetify-cli/master/install.sh | sh'
alias spicefix='spicetify backup apply'
