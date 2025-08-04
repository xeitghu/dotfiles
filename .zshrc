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

# 4.4. Metro
# Переходы
alias goconf='cd $DOTS'
alias godunst='cd $DOTS/dunst'
alias gohome='cd ~'
alias gohypr='cd $HYPR'
alias gokitty='cd $DOTS/kitty'
alias goscripts='cd $HYPR/scripts'
alias gowaybar='cd $DOTS/waybar'
alias gowofi='cd $DOTS/wofi'

# Редактирование
alias editbinds='nano $HYPR/keybinds.conf'
alias editcolors='nano $HYPR/colors.conf'
alias editdunst='nano $DOTS/dunst/dunstrc'
alias editff='nano $DOTS/fastfetch/config.jsonc'
alias editgitig='nano ~/.gitignore'
alias edithypr='nano $HYPR/hyprland.conf'
alias editkitty='nano $DOTS/kitty/kitty.conf'
alias editkittytheme='nano $DOTS/kitty/theme.conf'
alias editlook='nano $HYPR/look.conf'
alias editp10k='p10k configure'
alias editpaper='nano $HYPR/hyprpaper.conf'
alias editpower='nano $HYPR/scripts/powermenu.sh'
alias editpyre='nano ~/.local/bin/pyre'
alias editrules='nano $HYPR/window_rules.conf'
alias editwaybar='nano $DOTS/waybar/config'
alias editwaybarcolors='nano $DOTS/waybar/colors.css'
alias editwaybarstyle='nano $DOTS/waybar/style.css'
alias editwofistyle='nano $DOTS/wofi/style.css'
alias editzsh='nano ~/.zshrc'

# Вывод
alias catbinds='cat $HYPR/keybinds.conf'
alias catcolors='cat $HYPR/colors.conf'
alias catdunst='cat $DOTS/dunst/dunstrc'
alias catff='cat $DOTS/fastfetch/config.jsonc'
alias catgitig='cat ~/.gitignore'
alias cathypr='cat $HYPR/hyprland.conf'
alias catkitty='cat $DOTS/kitty/kitty.conf'
alias catkittytheme='cat $DOTS/kitty/theme.conf'
alias catlook='cat $HYPR/look.conf'
alias catpaper='cat $HYPR/hyprpaper.conf'
alias catpyre='cat ~/.local/bin/pyre'
alias catrules='cat $HYPR/window_rules.conf'
alias catwaybar='cat $DOTS/waybar/config'
alias catwaybarcolors='cat $DOTS/waybar/colors.css'
alias catwaybarstyle='cat $DOTS/waybar/style.css'
alias catwofistyle='cat $DOTS/wofi/style.css'
alias catzsh='cat ~/.zshrc'

# 4.5. Проект "Феникс" (Project "Phoenix")
# -----------------------------------------------------------------------------
# Псевдонимы и функции для управления кастомной средой и dotfiles

# 4.5.1. Управление Dotfiles (расширение для alias dotgit)
alias dstatus='dotgit status'
alias dadd='dotgit add'
alias dcommit='dotgit commit -m'
alias dpush='dotgit push'
alias dlog='dotgit log --oneline --graph --decorate'

# 4.5.2. Аудит новых Dotfiles
# Эта функция сканирует ключевые директории и находит файлы,
# которые вы еще не добавили в свой git-репозиторий.
dfindnew() {
    echo "🔎 Поиск новых, неотслеживаемых дотфайлов..."
    
    # Указываем git искать неотслеживаемые файлы только в этих директориях
    local untracked_files
    untracked_files=$(dotgit ls-files --others --exclude-standard -- ~/.config ~/.local/bin ~/.zshrc ~/.p10k.zsh)
    
    if [ -n "$untracked_files" ]; then
        echo "⚠️  Найдены новые файлы, не добавленные в Git:"
        echo "---------------------------------------------"
        # Выводим список файлов для наглядности
        echo "$untracked_files"
        echo "---------------------------------------------"
        echo "Используйте 'dadd <путь_к_файлу>' для их добавления."
    else
        echo "✅ Все конфигурационные файлы отслеживаются. Система в порядке."
    fi
}

# 4.5.3. Интеграция PHOENGINE
# -----------------------------------------------------------------------------
# Определяем имя и горячую клавишу для вызова нашего движка.
export PHOENGINE="pyre"

# Функция-виджет, теперь с консистентным именем.
phoengine_widget() {
    local cli_path="$HOME/.local/bin/$PHOENGINE"
    
    if [ -x "$cli_path" ]; then
        $cli_path
        zle redisplay
    else
        zle -M "Движок '$PHOENGINE' не найден в $HOME/.local/bin/ или не является исполняемым."
    fi
}
# Регистрируем функцию как виджет Zsh с тем же именем.
zle -N phoengine_widget

# Привязка виджета к комбинации Alt+H
bindkey '^ ' phoengine_widget

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
