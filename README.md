# 🌌 Arch Linux + Hyprland Dotfiles

![License](https://img.shields.io/github/license/xeitghu/dotfiles?style=for-the-badge&color=caa6f7)
![OS](https://img.shields.io/badge/OS-EndeavourOS-7c3aed?style=for-the-badge&logo=archlinux)
![WM](https://img.shields.io/badge/WM-Hyprland-40a4ff?style=for-the-badge&logo=c)

> **"Metro" Environment.** A highly modular, keyboard-centric, and aesthetic workspace built for DevOps engineering and Security research. 

<img width="1919" height="1078" alt="image" src="https://github.com/user-attachments/assets/1c1bab32-82f3-429c-a90d-4e61aca9608d" />

## ⚡ Philosophy

This repository is not just a collection of config files; it is an **Infrastructure as Code (IaC)** project for my personal workspace. 

The goal was to create a system that is:
1.  **Modular:** Every component (WM, Shell, Bar) is decoupled.
2.  **Maintainable:** Custom tooling (`Metro` system) makes managing configs instant.
3.  **Efficient:** VIM-like navigation everywhere, minimal mouse usage.

## 🛠️ The Stack

| Component | Choice | Description |
| :--- | :--- | :--- |
| **OS** | [EndeavourOS](https://endeavouros.com/) | Arch-based rolling release |
| **Compositor** | [Hyprland](https://hyprland.org/) | Dynamic tiling Wayland compositor |
| **Shell** | Zsh | Powered by custom `Metro` framework |
| **Terminal** | Kitty | GPU-accelerated, highly scriptable |
| **Bar** | Waybar | Custom JSON modules & bash scripts |
| **Launcher** | Wofi / FZF | Application & fuzzy finding |
| **Editor** | Neovim | LazyVim based configuration |
| **Browser** | Zen Browser | Firefox fork optimized for productivity |

---

## 🚇 The "Metro" Config System

The core of this repository is a custom Zsh framework I wrote to manage configuration complexity. It uses associative arrays to map aliases to file paths and integrates `fzf` + `bat` for live previews.

### Key Functions:

*   **`edit [alias]`**: Instantly open config files. Supports fuzzy searching.
    *   *Example:* `edit hypr` opens the Hyprland module menu.
    *   *Example:* `edit waybarconf` opens the config directly.
*   **`view [alias]`**: Inspect configuration files (with syntax highlighting) without opening an editor.
*   **`metro_modules`**: The logic separates "Files" from "Modules", allowing recursive editing of complex directories.

> *Source code location:* `zsh/06_functions.zsh`

---

## ⚡ Workflow & Productivity Features

Designed for a high-efficiency **DevOps** workflow:

*   **Instant OCR:** Built-in `ocr.sh` script (using `grim` + `slurp` + `tesseract`) to extract text from images/video directly to the clipboard.
*   **Clipboard Manager:** Integrated `cliphist` workflow with fuzzy search via Wofi.
*   **System Monitoring:** Custom JSON-based Waybar modules for real-time resource tracking and updates.
*   **Automation:** Custom scripts for system maintenance (`sysup`, `sysmenu`) and window management.

## 🚀 Installation

> ⚠️ **Warning:** These dotfiles are tailored to my specific hardware (AMD Ryzen + NVIDIA Hybrid). Review the `hyprland.conf` regarding `nvidia-drm` before applying.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/xeitghu/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    ```

2.  **Link configurations (using Stow or manual linking):**
    ```bash
    # Example manual link
    ln -s ~/.dotfiles/.config/hypr ~/.config/hypr
    ln -s ~/.dotfiles/.config/zsh ~/.config/zsh
    ```

3.  **Install dependencies (Arch Linux):**
    ```bash
    yay -S hyprland kitty waybar wofi dunst zsh starship fzf bat eza fd
    ```

## 📜 License

MIT License. Feel free to fork and adapt to your needs.
