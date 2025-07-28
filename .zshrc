#   ┌──────────────────────────────────────────────────┐
#   │                                                  │
#   │       ██╗  ██╗███████╗██╗  ██╗██████╗ ██████╗    │
#   │       ╚██╗██╔╝██╔════╝██║  ██║██╔══██╗██╔══██    │
#   │        ╚███╔╝ ███████╗███████║██████╔╝██║  ██    │
#   │        ██╔██╗ ╚════██║██╔══██║██╔══██╗██║  ██    │
#   │       ██╔╝ ██╗███████║██║  ██║██║  ██║██████╔    │
#   │       ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    │
#   │                                                  │
#   │        ~/.zshrc - Персональная конфигурация      │
#   │                                                  │
#   └──────────────────────────────────────────────────┘

# -----------------------------------------------------------------------------
# 1. ПЕРЕМЕННЫЕ СРЕДЫ И ПУТИ (ENVIRONMENT & PATH)
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nano'
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:$HOME/.lmstudio/bin"
export DOTS="$HOME/.config"
export HYPR="$DOTS/hypr"

# -----------------------------------------------------------------------------
# 2. НАСТРОЙКИ ZSH И OH MY ZSH
# -----------------------------------------------------------------------------
export ZSH_THEME="powerlevel10k/powerlevel10k"
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE
zstyle ':omz:update' mode reminder

# -----------------------------------------------------------------------------
# 3. ПЛАГИНЫ (PLUGINS)
# -----------------------------------------------------------------------------
plugins=(
  git
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# -----------------------------------------------------------------------------
# 4. ПСЕВДОНИМЫ (ALIASES)
# -----------------------------------------------------------------------------

# 4.1. Управление пакетами (Arch / yay)
alias update='yay -Syu'
alias install='yay -S'
alias remove='sudo pacman -Rns'
alias search='yay -Ss'

# 4.2. Замена стандартных утилит
# ПРОСМОТР
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --git --group-directories-first --header'
alias la='eza -lha --icons --git --group-directories-first --header'
alias cat='bat --paging=never --style=plain'
alias less='bat'
# АНАЛИЗ
alias lt='eza --tree --level=2 --icons'
alias lsz='eza -lrh --sort=size --icons'
alias ld='eza -lrh --sort=modified --icons'
# ПОИСК
alias find='fd'
alias grep='rg'
# МОНИТОРИНГ
alias top='btop'
alias df='duf'

# 4.3. Навигация и удобство
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'

# 4.4. Быстрый доступ к конфигам ("Метро")
# Переходы
alias goconf='cd $DOTS'
alias gohome='cd ~'
alias gohypr='cd $HYPR'
alias gowaybar='cd $DOTS/waybar'
alias gokitty='cd $DOTS/kitty'
alias gowofi='cd $DOTS/wofi'
alias godunst='cd $DOTS/dunst'
alias goscripts='cd $HYPR/scripts'
# Редактирование
alias editzsh='nano ~/.zshrc'
alias editp10k='p10k configure'
alias edithypr='nano $HYPR/hyprland.conf'
alias editbinds='nano $HYPR/keybinds.conf'
alias editrules='nano $HYPR/window_rules.conf'
alias editlook='nano $HYPR/look.conf'
alias editpaper='nano $HYPR/hyprpaper.conf'
alias editwaybar='nano $DOTS/waybar/config'
alias editwaybarstyle='nano $DOTS/waybar/style.css'
alias editkitty='nano $DOTS/kitty/kitty.conf'
alias editwofistyle='nano $DOTS/wofi/style.css'
alias editff='nano $DOTS/fastfetch/config.jsonc'
#Вывод
alias catzsh='cat ~/.zshrc'
alias cathypr='cat $HYPR/hyprland.conf'  
alias catbinds='cat $HYPR/keybinds.conf'
alias catlook='cat $HYPR/look.conf'
alias catwaybar='cat $DOTS/waybar/config'
alias catwaybarstyle='cat $DOTS/waybar/style.css'
alias catkitty='cat $DOTS/kitty/kitty.conf'
alias catwofistyle='cat $DOTS/wofi/style.css'
alias catff='cat $DOTS/fastfetch/config.jsonc'

# -----------------------------------------------------------------------------
# 5. ФУНКЦИИ (FUNCTIONS)
# -----------------------------------------------------------------------------
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
            *)          echo "'$1' не может быть распакован" ;;
        esac
    else
        echo "'$1' - не валидный файл"
    fi
}

mkcd() {
    mkdir -p "$1" && cd "$1"
}

# -----------------------------------------------------------------------------
# 6. ИНИЦИАЛИЗАЦИЯ И ЗАПУСК
# -----------------------------------------------------------------------------
# Загрузка Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Загрузка Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Загрузка fzf (для Ctrl+R и Ctrl+T)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Команды при старте терминала ---
fastfetch
alias dotgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
