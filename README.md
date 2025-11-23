<div align="center">
    <!-- ЛОГОТИП: Теперь используется векторный SVG логотип Arch Linux -->
    <img src="https://upload.wikimedia.org/wikipedia/commons/7/74/Arch_Linux_logo.svg" alt="Logo" width="120" />
    
    <h1>Metro Dotfiles</h1>
    <p>
        <b>A highly modular, aesthetic, and performance-oriented Hyprland configuration.</b><br>
        Powered by the custom <i>Pyre Engine</i> for dynamic theming.
    </p>

<!-- БЕЙДЖИ -->
![Stars](https://img.shields.io/github/stars/xeitghu/dotfiles?style=for-the-badge&color=cba6f7)
![Forks](https://img.shields.io/github/forks/xeitghu/dotfiles?style=for-the-badge&color=89b4fa)
![License](https://img.shields.io/github/license/xeitghu/dotfiles?style=for-the-badge&color=a6e3a1)

</div>

---

<!-- ГЛАВНЫЙ СКРИНШОТ -->
<div align="center">
    <!-- Используем твою ссылку на изображение -->
    <img src="https://github.com/user-attachments/assets/7f3913fb-a640-460c-a6f0-cd8a448cdbdd" alt="Desktop Preview" width="100%" style="border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.5);" />
</div>

---

## ⚡ Overview

This repository contains my personal configuration files (dotfiles) for Arch Linux. It is built around **Hyprland** and follows the "Metro" design philosophy: strictly organized, modular, and keyboard-centric.

### 🛠 Tech Stack

| Component | Choice | Description |
|-----------|--------|-------------|
| **OS** | Arch Linux | The base system |
| **WM** | Hyprland | Dynamic tiling Wayland compositor |
| **Shell** | Zsh | Modular config with extensive aliases |
| **Terminal** | Kitty | GPU-accelerated, highly configurable |
| **Editor** | Neovim | LazyVim based, fully IDE-like |
| **Bar** | Waybar | Custom CSS, informative modules |
| **Launcher** | Wofi | App launcher and clipboard manager |
| **Lock** | Hyprlock | Native screen locking utility |
| **Idle** | Hypridle | Idle management daemon |
| **Clipboard**| Clipse | TUI-based clipboard history manager |
| **Notifications** | Dunst | Minimalist notification daemon |

---

## 📸 Gallery

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7f3913fb-a640-460c-a6f0-cd8a448cdbdd" />

---

## 🔥 Key Features

### 1. The Pyre Engine (`.config/pyre/`)
A custom bash-based engine that handles system state, theming, and automation.
- **Dynamic Theming:** Instantly switches wallpapers and colors across Waybar, Hyprland, and Kitty.
- **State Management:** Remembers your last used theme and layout across reboots.

### 2. Modular Zsh System (`.config/zsh/`)
Gone is the giant `.zshrc`. The shell configuration is split into logical modules:
- `01_environment.zsh`: Paths and export variables.
- `02_options.zsh`: History and shell behavior.
- `03_plugins.zsh`: Plugin management.
- `04_fzf.zsh`: Fuzzy finder integration.
- `05_aliases.zsh`: Structured aliases (including the `dotgit` helper).
- `06_functions.zsh`: Custom utility functions.

### 3. WPR - Wallpaper Picker (`.local/bin/wpr`)
A rewritten, interactive wallpaper manager.
- **Interactive:** `wpr` opens a Wofi menu to select wallpapers.
- **Random:** `wpr -r` sets a random wallpaper from the current theme.
- **All:** `wpr -a` lets you pick from your entire collection.

---

## 🚀 Installation

### 1. Dependencies
Ensure you have the required packages. On Arch Linux (using `yay`):

```bash
# Core System
yay -S hyprland hyprlock hypridle waybar wofi dunst kitty zsh starship

# Tools & Utilities
yay -S clipse brightnessctl playerctl pamixer swww grim slurp ttf-jetbrains-mono-nerd

# Neovim & build tools
yay -S neovim npm ripgrep fd
```

> **Note:** A Nerd Font (like JetBrains Mono) is required for icons to render correctly.

### 2. Clone the Repository
Clone the repo into your home directory (or wherever you prefer, but paths might need adjustment).

```bash
git clone https://github.com/xeitghu/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 3. Initialize Neovim Submodule
Since Neovim configuration is tracked as a submodule:

```bash
git submodule update --init --recursive
```

### 4. Link Configurations
I recommend using **GNU Stow** to manage symlinks, or you can link manually.

**Using Stow (Recommended):**
```bash
# Warning: Backup your existing configs first!
cd ~/.dotfiles
stow .
```

---

## ⌨️ Keybindings Cheat Sheet

Here are the most essential Hyprland bindings to get you started.

| Key Combination | Action |
|-----------------|--------|
| `Super + Enter` | Open **Terminal** (Kitty) |
| `Super + Q` | **Close** active window |
| `Super + D` | Open **App Launcher** (Wofi) |
| `Super + E` | Open **File Manager** (Thunar) |
| `Super + F` | Toggle **Floating** mode |
| `Super + P` | Launch **Pyre** Dashboard |
| `Super + V` | Open **Clipboard History** (Clipse) |
| `Super + Shift + X` | **Lock Screen** |
| `Super + Shift + E` | **Exit** Hyprland |

<details>
<summary>Click to see Window Management keys</summary>

- `Super + H/J/K/L`: Move focus
- `Super + Shift + H/J/K/L`: Move window
- `Super + 1-0`: Switch workspace
- `Super + Shift + 1-0`: Move window to workspace
- `Super + S`: Toggle Scratchpad
</details>

---

## 📂 Structure

```graphql
~/.dotfiles
├── .config/
│   ├── hypr/          # Hyprland (Conf, Rules, Scripts)
│   ├── zsh/           # Modular Shell Config
│   ├── waybar/        # Status Bar
│   ├── nvim/          # Neovim (Submodule)
│   ├── pyre/          # Custom Engine Scripts
│   └── ...            # Other apps (kitty, wofi, etc.)
├── .local/
│   └── bin/           # Custom executables (wpr, pyre, etc.)
└── .zshrc             # Entry point for Zsh
```

---

<div align="center">
    <p><i>Crafted with ❤️ by xeitghu</i></p>
</div>
