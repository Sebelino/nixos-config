# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Arch Linux Package Management (t14s)
- `yay -S package_name` - Install packages from official repos or AUR
- `yay -S --needed --noconfirm - < pkgs-essentials.txt` - Install packages from file
- `pacman -Qi package_name` - Query package info
- `yay -R package_name` - Remove packages

### Environment Setup Scripts (t14s - Arch Linux)
- `bash ~/nixos-config/environments/t14s/install-essentials.sh` - Install essential packages
- `bash ~/nixos-config/environments/t14s/sysconfigure.sh` - Create symlinks for dotfiles
- `bash ~/nixos-config/environments/t14s/install-apps.sh` - Install additional applications
- `bash ~/nixos-config/environments/t14s/enable-daemons.sh` - Enable system services

### Environment Setup Scripts (m4 - macOS)
- `bash ~/src/nixos-config/environments/m4/sysconfigure.sh` - Create symlinks for dotfiles

### Configuration Management
- **Primary environments**: `environments/t14s/` (Arch Linux) and `environments/m4/` (macOS ARM64)
- Legacy NixOS configs: `configuration.nix`, `home.nix` (no longer maintained)
- Package lists (t14s): `pkgs-essentials.txt`, `pkgs-apps.txt`, `pkgs-multilib.txt`

## Architecture Overview

This repository started as a NixOS configuration but has evolved into a dotfiles repository for Arch Linux and macOS. Active development happens in `environments/t14s/` and `environments/m4/`.

### environments/t14s/ (Arch Linux on ThinkPad T14s Gen 3)

**Key Configuration Files:**
- `display/sway/config` - Sway window manager (Wayland)
- `statusbar/waybar/` - Waybar status bar
- `editor/nvim/` - Neovim with init.lua
- `terminal/alacritty/` - Alacritty terminal
- `shell/zsh/` - Zsh configuration
- `keyboard/` - Custom solemak layout (XKB)

**Package Lists:** `pkgs-essentials.txt`, `pkgs-apps.txt`, `pkgs-multilib.txt`

**Setup Scripts:**
- `bootstrap-from-root.sh` → `bootstrap-from-user.sh` → `install-essentials.sh` → `sysconfigure.sh` → `enable-daemons.sh`

### environments/m4/ (macOS ARM64 - Mac Mini M4)

**Key Configuration Files:**
- `display/aerospace/aerospace.toml` - AeroSpace window manager
- `keyboard/karabiner/` - Karabiner keyboard remapping
- `shell/zsh/` - Zsh configuration (zshrc, aliases.zsh)

**Setup:** `bash sysconfigure.sh` to create symlinks

### Shared Components
- `lib/common.sh` - Symlink/copy utility functions used by sysconfigure.sh scripts
- `bin/` - Utility scripts for system management
- `secrets/` - git-crypt encrypted files (GPG keys, SSH keys)

### Symlink Pattern
Each environment's `sysconfigure.sh` uses `lib/common.sh` to create symlinks:
```bash
source "${scriptdir}/../../lib/common.sh"
symlink "shell/zsh/zshrc" "$HOME/.zshrc"
```

### Key Technical Details
- **t14s**: Sway/Wayland, Zsh, Neovim, Alacritty, PipeWire, AMD GPU, LUKS encryption
- **m4**: AeroSpace, Zsh with Oh-My-Zsh + Starship, Karabiner

### Common Operations
- **Dotfile management**: Run `sysconfigure.sh` in the relevant environment directory
- **GPG setup**: Required for decrypting git-crypt files with `git crypt unlock`
- **Git LFS**: Run `git lfs install && git lfs pull` for binary blobs