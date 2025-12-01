# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Arch Linux Package Management (Primary Environment)
- `yay -S package_name` - Install packages from official repos or AUR
- `yay -S --needed --noconfirm - < pkgs-essentials.txt` - Install packages from file
- `pacman -Qi package_name` - Query package info
- `yay -R package_name` - Remove packages

### Environment Setup Scripts (t14s - Arch Linux)
- `bash ~/nixos-config/environments/t14s/install-essentials.sh` - Install essential packages
- `bash ~/nixos-config/environments/t14s/sysconfigure.sh` - Create symlinks for dotfiles
- `bash ~/nixos-config/environments/t14s/install-apps.sh` - Install additional applications
- `bash ~/nixos-config/environments/t14s/enable-daemons.sh` - Enable system services

### Legacy NixOS Commands (Deprecated)
- `sudo nixos-rebuild switch` (alias: `nrs`) - Apply NixOS configuration changes
- Note: NixOS configs exist but are no longer actively maintained

### Configuration Management
- **Primary environment**: `environments/t14s/` (Arch Linux on ThinkPad T14s Gen 3)
- Legacy NixOS configs: `configuration.nix`, `home.nix`
- Package lists: `pkgs-essentials.txt`, `pkgs-apps.txt`, `pkgs-multilib.txt`

## Architecture Overview

This repository started as a NixOS configuration but has evolved into a dotfiles repository primarily focused on Arch Linux setup. The active development happens in `environments/t14s/`.

### Primary Environment: environments/t14s/ (Arch Linux)
The main active configuration for ThinkPad T14s Gen 3 running Arch Linux with Sway (Wayland):

**Key Configuration Files:**
- `display/sway/config` - Sway window manager configuration
- `statusbar/waybar/` - Waybar status bar for Wayland
- `editor/nvim/` - Neovim configuration with init.lua
- `terminal/alacritty/` - Alacritty terminal emulator config
- `shell/zsh/` - Zsh shell configuration
- `keyboard/` - Custom solemak keyboard layout and XKB config
- `audio/cmus/` - Music player configuration
- `browser/chromium/` - Chromium browser flags
- `security/gnupg/` - GPG configuration

**Package Management:**
- `pkgs-essentials.txt` - Core system packages
- `pkgs-apps.txt` - Additional applications 
- `pkgs-multilib.txt` - Multilib packages (Wine, Adobe, etc.)

**Setup Scripts:**
- `bootstrap-from-root.sh` - Initial root user setup
- `bootstrap-from-user.sh` - User configuration setup
- `sysconfigure.sh` - Creates symlinks for all dotfiles
- `install-*.sh` - Various installation scripts for different components

### Legacy Components (Inactive)
- **Root level configs** - NixOS configuration files (no longer maintained)
  - `configuration.nix`, `home.nix`, `packages-home.nix`
  - `environments/zenia/` - NixOS hardware configuration
- **Shared configs** - Still used by t14s environment:
  - `bin/` - Utility scripts for system management
  - `secrets/` - Encrypted files (GPG keys, SSH keys)
  - `pdfviewer/`, `theme/` - Shared application configs

### Key Technical Details
- **Window Manager**: Sway (Wayland) with Waybar status bar
- **Shell**: Zsh with extensive Git aliases and custom functions
- **Editor**: Neovim with Lua configuration
- **Terminal**: Alacritty with custom configuration
- **Keyboard**: Custom solemak layout with XKB configuration
- **Audio**: PipeWire with PulseAudio compatibility
- **Graphics**: AMD GPU with potential power management tweaks
- **Security**: LUKS disk encryption, GPG key management

### Common Operations
- **System setup**: Run bootstrap scripts in order for fresh installs
- **Package installation**: Use yay with package list files
- **Dotfile management**: `sysconfigure.sh` creates all necessary symlinks
- **GPG setup**: Required for decrypting git-crypt files with `git crypt unlock`
- **Custom ISO**: Build custom Arch ISO with sarch-* scripts