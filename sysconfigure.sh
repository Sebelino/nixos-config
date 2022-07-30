#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

symlink() {
    src="$scriptdir/$1"
    dst="$2"

    dstdir="$(dirname "$dst")"
    mkdir -p "$dstdir"

    if [ -h "$dst" -a ! -e "$dst" ]; then
        echo "Error: Symlink is broken: $dst"
        exit 1
    elif [ -L "$dst" ]; then
        echo "Already symlinked: $dst"
    elif [ -f "$dst" ]; then
        echo "Error: Already exists and is a file: $dst" >&2
        exit 1
    else
        echo "Symlinking: $src -> $dst"
        ln -s "$src" "$dst"
    fi
}

copy() {
    src="$scriptdir/$1"
    dst="$2"

    if [ ! -f "$dst" ]; then
        echo "Copying: $src -> $dst"
        cp "$src" "$dst"
    else
        echo "Already present: $dst"
    fi
}

symlink "login/xinitrc" "$HOME/.xinitrc"
symlink "login/zprofile" "$HOME/.zprofile"
symlink "bin" "$HOME/bin"
symlink "secrets/adx/id_ed25519" "$HOME/.ssh/id_ed25519"
symlink "secrets/adx/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
symlink "windowmanager/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
symlink "terminal/Xresources" "$HOME/.Xresources"
symlink "statusbar/xmobarrc" "$HOME/.xmobarrc"
symlink "editor/vimrc" "$HOME/.vimrc"
symlink "shell/zshrc" "$HOME/.zshrc"
symlink "shell/zshenv" "$HOME/.zshenv"
symlink "cmus/rc" "$HOME/.config/cmus/rc"
symlink "theme/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
symlink "theme/gtkrc-2.0" "$HOME/.gtkrc-2.0"
symlink "editor/nvim/init.vim" "$HOME/.config/nvim/init.vim"
symlink "pdfviewer/zathurarc" "$HOME/.config/zathura/zathurarc"
symlink "keyboard/solaar/config.p14s.yaml" "$HOME/.config/solaar/config.yaml"
symlink "keyboard/solaar/rules.yaml" "$HOME/.config/solaar/rules.yaml"
symlink "keyboard/xbindkeysrc" "$HOME/.xbindkeysrc"
symlink "filemanager/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
symlink "notify/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
symlink "vcs/gitconfig" "$HOME/.gitconfig"

# ~/.xscreensaver apparently can't be a symlink
copy "screensaver/xscreensaver" "$HOME/.xscreensaver"

echo "Reloading any changes to the terminal..."
xrdb "$HOME/.Xresources"

echo "Making /usr/share/X11/xkb/symbols/ writable to allow creating symlinks in it..."
sudo chmod o+w /usr/share/X11/xkb/symbols/

echo "Adding $USER to video group to allow using light to control screen brightness..."
echo "Adding $USER to nix-users to use Nix..."
sudo usermod -aG video,nix-users $USER

symlink "keyboard/xkb/solemak" "/usr/share/X11/xkb/symbols/solemak"
symlink "keyboard/xkb/sesebel" "/usr/share/X11/xkb/symbols/sesebel"
