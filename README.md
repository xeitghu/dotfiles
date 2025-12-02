# 🌌 Metro Dotfiles

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-2D3748?style=for-the-badge&logo=hyprland&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Zsh](https://img.shields.io/badge/Zsh-F15A24?style=for-the-badge&logo=zsh&logoColor=white)

> **A highly modular, aesthetic, and performance-oriented Hyprland configuration.**  
> Crafted with the **Metro** design philosophy: strictly organized, modular, and keyboard-centric.

---

<div align="center">
<img src="https://github.com/user-attachments/assets/7f3913fb-a640-460c-a6f0-cd8a448cdbdd" alt="Desktop Preview" width="100%" style="border-radius: 10px; box-shadow: 0px 4px 10px rgba(0,0,0,0.5);" />
</div>

---

## 📑 Table of Contents

- [⚡ Overview](#-overview)
- [🛠 Tech Stack](#-tech-stack)
- [🔥 Key Features](#-key-features)
  - [Metro System](#1-the-metro-system-configzsh)
  - [The Pyre Engine](#2-the-pyre-engine-configpyre)
  - [Modular Zsh](#3-modular-zsh-system-configzsh)
  - [Wallpaper Picker (WPR)](#4-wpr---wallpaper-picker-localbinwpr)
- [📂 Project Structure](#-project-structure)
- [🚀 Installation](#-installation)
- [⌨️ Keybindings](#️-keybindings)
- [🎨 Customization](#-customization)
- [📄 License](#-license)

---

## ⚡ Overview

**Metro Dotfiles** is not just a collection of config files; it is a cohesive *environment* built for Hyrpland. The core philosophy revolves around:

1.  **Modularity**: Every component is isolated. Breaking one thing doesn't break the system.
2.  **Aesthetics**: Consistent **Catppuccin Mocha** color palette across all applications.
3.  **Performance**: Minimal overhead using native Wayland tools.
4.  **Workflow**: Keyboard-driven navigation with Vim-like bindings everywhere.

Powered by the custom **Pyre Engine**, this setup offers dynamic theming and state management that persists across reboots.

---

## 🛠 Tech Stack

The system is built upon a robust selection of modern Wayland tools:

| Component | Software | Why? |
| :--- | :--- | :--- |
| **OS** | [Arch Linux](https://archlinux.org/) | Rolling release, total control. |
| **WM** | [Hyprland](https://hyprland.org/) | Fluid animations, dynamic tiling, highly scriptable. |
| **Shell** | [Zsh](https://www.zsh.org/) | Powerful interactive shell with Powerlevel10k. |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated, supports image previews. |
| **Editor** | [Neovim](https://neovim.io/) | Lightning fast, configured with LazyVim. |
| **Bar** | [Waybar](https://github.com/Alexays/Waybar) | Highly customizable JSON/CSS status bar. |
| **Launcher** | [Wofi](https://hg.sr.ht/~scoopta/wofi) | Wayland-native launcher and menu. |
| **Lock Screen** | [Hyprlock](https://github.com/hyprwm/hyprlock) | Simple, effective, and secure locking. |
| **Idle Daemon** | [Hypridle](https://github.com/hyprwm/hypridle) | Efficient idle management. |
| **Notifications** | [Dunst](https://dunst-project.org/) | Minimalist, unobtrusive notifications. |
| **Clipboard** | [Clipse](https://github.com/saved/clipse) | TUI-based clipboard manager. |

---

## 🔥 Key Features

### 1. The Metro System (`.config/zsh/06_functions.zsh`)
The core of this environment is the **Metro System**—an intelligent registry that maps short aliases to complex file paths and modular directories. Instead of memorizing where every config file lives, you use the Metro Dispatcher.

#### 🧠 The Central Registry
The system utilizes Zsh associative arrays (`typeset -A`) to create a "Config Map". This allows for instantaneous navigation regardless of where the actual file is located on the disk.

| Command | Action | Implementation |
| :--- | :--- | :--- |
| **`edit`** | Opens the **Metro Dashboard** (FZF menu) to select a config to edit. | `nvim $file` |
| **`edit <alias>`** | Instantly opens a specific file (e.g., `edit hypr` or `edit polybar`). | Direct jump |
| **`view`** | Opens the **Metro Viewer** (FZF menu) to preview files without editing. | `bat $file` |
| **`view <alias>`** | Previews a specific config or file tree. | `eza --tree` / `bat` |

**Example Mappings:**
*   `edit hyprconf` → Opens `~/.config/hypr/hyprland.conf`
*   `edit theme` → Opens `~/.config/hypr/theme.conf`
*   `edit nvim` → Opens `~/.config/nvim/lua/config/lazy.lua`

#### ⚡ Workflow Utilities
The Metro System includes a suite of context-aware functions designed to speed up terminal usage:

*   **🪄 Magic Enter**: Pressing `Enter` on an empty command line automatically runs `eza` (ls) and checks `git status`. If the directory is clean, it just lists files.
*   **📂 `pj` (Project Jumper)**: Scans your `~/Projects`, `~/Documents`, and dotfiles for git repositories. Select one via FZF to instantly `cd` into it.
*   **🔍 `rf` (Ripgrep Fzf)**: Interactively search for a string across the *entire* current project. Press Enter to jump to that specific line in Neovim.
*   **📄 `fin` (Find Inside)**: Fuzzy-search *inside* a specific file. Great for finding that one variable in a 2000-line config.
*   **💀 `fk` (Fuzzy Kill)**: Interactive process killer. Filters your processes via FZF and sends `kill -9` to the selection.
*   **🛡️ `dfd` (Dotfiles Doctor)**: Audits your home directory for untracked configuration files that *should* be in your dotfiles repo but aren't.

### 2. The Pyre Engine (`.config/pyre/`)
At the heart of this configuration lies the **Pyre Engine**, a custom bash-based framework designed to bridge the gap between static configs and dynamic user needs.

*   **Global State**: Tracks current wallpaper, theme mode (dark/light), and active layout.
*   **Instant Theming**: When you switch a theme, Pyre broadcasts changes to Hyprland, Waybar, and Kitty instantly without requiring a full restart.
*   **Persistence**: Your environment looks exactly the same after a reboot.

### 3. Modular Zsh System (`.config/zsh/`)
We abandoned the monolithic `.zshrc` file in favor of a clean, sourced structure:

*   **`01_environment.zsh`**: Defines `$PATH`, editor variables, and XDG directories.
*   **`02_options.zsh`**: Configures history size, stack interaction, and shell behavior.
*   **`03_plugins.zsh`**: Manages plugins (Autosuggestions, Syntax Highlighting) efficiently.
*   **`04_fzf.zsh`**: Deep integration with `fzf` for file searching and command history.
*   **`05_aliases.zsh`**: A curated list of aliases (e.g., `ll`, `g` for git, `v` for nvim).
*   **`06_functions.zsh`**: Advanced utility functions like `extract` and automatic directory creation.

### 4. WPR - Wallpaper Picker (`.local/bin/wpr`)
A custom tool written to manage aesthetics seamlessly.

*   **GUI Mode**: Run `wpr` to open a visual grid of wallpapers in Wofi.
*   **Randomizer**: Run `wpr -r` to surprise yourself with a new look from your collection.
*   **Collection Management**: Supports adding/removing wallpapers dynamically.

---

## 📸 Gallery

### 💎 The Desktop Experience
> Minimal clutter, maximum information. The status bar adapts to context, and windows tile dynamically.

| **The Command Center** | **Media & Entertainment** |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/683420a1-3496-4821-a1df-b6249de13066" alt="Neovim Setup" width="100%"> | <img src="https://github.com/user-attachments/assets/ed893409-6189-4324-9bb0-63f422e48f8a" alt="Media Player" width="100%"> |
| *Productivity focused: Neovim & Terminal* | *Relaxing: Spotify & Cava Visualizer* |

| **Floating Mode** | **The Dashboard** |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/b3794ec1-6ae8-4cbf-937c-e531bbe4ff82" alt="Floating Windows" width="100%"> | <img src="https://github.com/user-attachments/assets/b957db02-5d44-48d8-aa2a-9e9d398b39aa" alt="Wofi Launcher" width="100%"> |
| *True multitasking with Picture-in-Picture* | *Quick access via Wofi / App Launcher* |

---


### 🚇 The Metro System in Action
> The `edit` command in action. Instantly fuzzy-search through 50+ config files and modules without leaving the terminal.

<img src="https://github.com/user-attachments/assets/276ada1f-b9ae-4680-85ac-12e20bd1b427" alt="Metro Dispatcher" width="100%">

---

### 🔒 Security
> **Hyprlock**: Minimal, fast, and secure lockscreen.

<div align="center">
  <img src="https://github.com/user-attachments/assets/f9288866-23c5-4c20-9ef8-88552dd5e97d" alt="Hyprlock Screen" width="80%">
</div>

---

## 📂 Project Structure

A bird's-eye view of how the dotfiles are organized. This structure ensures easy maintenance and portability.

```graphql
~/.dotfiles
├── .config/
│   ├── hypr/           # Hyprland main config, window rules, keybinds
│   ├── zsh/            # The modular Zsh configuration
│   ├── waybar/         # Status bar layout and style.css
│   ├── nvim/           # Neovim configuration (LazyVim based)
│   ├── pyre/           # Pyre Engine core scripts
│   ├── kitty/          # Terminal emulator config
│   ├── wofi/           # Launcher styling
│   ├── dunst/          # Notification daemon settings
│   └── ...
├── .local/
│   └── bin/            # Executables added to $PATH (wpr, pyre, etc.)
├── .p10k.zsh           # Powerlevel10k theme configuration
├── .zshrc              # Sourcing entry point
├── LICENSE             # MIT License
└── README.md           # Documentation
```

---

## 💻 Hardware & Compatibility

This configuration is daily driven on a **Laptop** with a Hybrid GPU setup. It is optimized for the **Zen Kernel** to balance performance and latency.

| Component | Spec | Configuration Notes |
| :--- | :--- | :--- |
| **Device** | Laptop | Optimized for mobility (battery & power profiles). |
| **CPU** | AMD Ryzen 5 5600H | 6 Cores / 12 Threads. |
| **GPU (iGPU)** | AMD Radeon Vega | Primary renderer for desktop (Power saving). |
| **GPU (dGPU)** | NVIDIA GTX 1650 | Used for heavy tasks (`prime-run`). Driver: `580.xx`. |
| **OS** | EndeavourOS | Arch-based. Running `linux-zen` kernel. |

> **⚠️ Hybrid Graphics Notice:**  
> This setup uses standard **Nvidia Proprietary Drivers** (v580+).
> *   Make sure `NVIDIA_DRM_MODESET=1` is set in your environment.
> *   The config assumes standard Wayland wrapping. If you face flickering, check the `hypr/hyrpalnd.conf` NVIDIA specific rules.

## 🚀 Installation

### Prerequisites
Make sure you are running a fresh install of **Arch Linux**.

1.  **Install a Nerd Font**: Essential for icons.
    ```bash
    yay -S ttf-jetbrains-mono-nerd
    ```

### Step 1: Install Dependencies
Install all required packages using `yay` (or your preferred AUR helper).

```bash
# Core Desktop Components
yay -S hyprland hyprlock hypridle waybar wofi dunst kitty zsh starship

# Utilities & Tools
yay -S clipse brightnessctl playerctl pamixer swww grim slurp polkit-gnome

# Neovim Ecosystem
yay -S neovim npm ripgrep fd
```

### Step 2: Clone the Repository
Clone into your home directory.

```bash
git clone https://github.com/xeitghu/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Step 3: Handle Submodules
Initialize the Neovim configuration (and any other submodules).

```bash
git submodule update --init --recursive
```

### Step 4: Link Configurations
Use **GNU Stow** to symlink files safely. This keeps your home directory clean and your git repo organized.

```bash
# BACKUP your existing configs before running this!
cd ~/.dotfiles
stow .
```

*Alternative:* If you prefer manual linking:
`ln -s ~/.dotfiles/.config/hypr ~/.config/hypr` (repeat for each folder).

---

## ⌨️ Keybindings

The workflow is keyboard-centric. The `Super` key (Windows key) is the main modifier.

### 🖥️ Window Management
| Key | Action |
| :--- | :--- |
| `Super + Q` | **Close** active window |
| `Super + F` | Toggle **Floating** / Tiling mode |
| `Super + S` | Toggle **Scratchpad** (Special Workspace) |
| `Super + P` | Toggle **Pseudo-tiling** |
| `Super + J` | Toggles **Split** direction |
| `Super + H/J/K/L` | **Focus** window (Vim direction) |
| `Super + Shift + H/J/K/L` | **Move** window (Vim direction) |
| `Super + Left/Right` | **Resize** active window |

### 🚀 Application Launchers
| Key | Action |
| :--- | :--- |
| `Super + Enter` | Open **Kitty** (Terminal) |
| `Super + D` | Open **Wofi** (App Launcher) |
| `Super + E` | Open **Thunar** (File Manager) |
| `Super + B` | Open **Browser** (Default) |
| `Super + V` | Open **Clipse** (Clipboard History) |
| `Super + P` | Launch **Pyre Dashboard** |

### 🛠️ System Control
| Key | Action |
| :--- | :--- |
| `Super + Shift + X` | **Lock Screen** |
| `Super + Shift + E` | **Exit** Hyprland (Logout) |
| `Fn + Vol Up/Down` | Adjust Volume |
| `Fn + Brightness` | Adjust Brightness |

---

## 🎨 Customization

### Changing the Color Scheme
The system uses a centralized color config located in `.config/pyre/colors`.
1. Edit the hex codes in that file.
2. Run `pyre reload` to apply changes globally.

### Adding New Wallpapers
1. Place your images in `~/Pictures/Wallpapers/`.
2. Run `wpr` to see them immediately in the picker.

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or want to improve the Pyre Engine:

1.  Fork the repository.
2.  Create a feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes.
4.  Push to the branch.
5.  Open a Pull Request.

---

## ❓ FAQ

**Q: Why are my icons missing?**
A: Ensure you have installed a **Nerd Font**. I recommend `JetBrainsMono Nerd Font`. Run: `fc-cache -fv` after installing.

**Q: The terminal colors look wrong.**
A: Make sure you are using **Kitty**. If using another terminal, you must manually apply the Catppuccin theme to it.

**Q: How do I update the dotfiles?**
A: Just run `git pull` inside `~/.dotfiles`. To update submodules (like Neovim plugins), run `git submodule update --remote`.

**Q: Metro `edit` command isn't working.**
A: Ensure `~/.local/bin` is in your `$PATH`. The installer script should handle this, but you can check with `echo $PATH`.

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

<div align="center">
  <sub>Crafted with ❤️ by <a href="https://github.com/xeitghu">xeitghu</a></sub>
</div>
