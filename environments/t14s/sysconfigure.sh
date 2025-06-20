#!/usr/bin/env bash

set -euo pipefail

scriptdir="$(dirname "$(realpath "$0")")"

source "${scriptdir}/../../lib/common.sh"

if [ ! -L "$HOME/.ssh/id_ed25519" ]; then
    echo "Converting .ssh/ files into symlinks..."
    rm "$HOME/.ssh/id_ed25519"
    rm -f "$HOME/.ssh/id_ed25519.pub"
fi

symlink "locale/locale.conf" "$HOME/.config/locale.conf"
symlink "vcs/gitconfig" "$HOME/.gitconfig"
symlink "vcs/gitignore_global" "$HOME/.gitignore_global"
symlink "security/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
symlink "security/gnupg/gpg.conf" "$HOME/.gnupg/gpg.conf"
symlink "shell/zdotdir.zshenv" "$HOME/.zshenv"
symlink "shell/zsh" "$HOME/.config/zsh"
symlink "shell/zsh/.zshrc" "$HOME/.zshrc"
symlink "terminal/alacritty" "$HOME/.config/alacritty"
symlink "editor/nvim" "$HOME/.config/nvim"
symlink "audio/cmus/rc" "$HOME/.config/cmus/rc"
symlink "keyboard/xkb" "$HOME/.xkb"
symlink "keyboard/XCompose" "$HOME/.XCompose"
symlink "mouse/solaar" "$HOME/.config/solaar"
symlink "statusbar/waybar" "$HOME/.config/waybar"
symlink "filemanager/lf" "$HOME/.config/lf"
symlink "open/mimeapps.list" "$HOME/.config/mimeapps.list"
symlink "../../pdfviewer/zathurarc" "$HOME/.config/zathura/zathurarc"
symlink "../../secrets/id_ed25519" "$HOME/.ssh/id_ed25519"
symlink "../../ssh/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
symlink "../../theme/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
symlink "../../theme/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
symlink "../../theme/gtkrc-2.0" "$HOME/.gtkrc-2.0"
symlink "../../bin" "$HOME/bin"
symlink "browser/chromium/chromium-flags.conf" "$HOME/.config/chromium-flags.conf"
symlink "notify/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
symlink "vm/libvirt/libvirt.conf" "$HOME/.config/libvirt/libvirt.conf"
symlink "display/sway" "$HOME/.config/sway"
symlink "display/kanshi" "$HOME/.config/kanshi"
symlink "mouse/mousemapper.service" "$HOME/.config/systemd/user/mousemapper.service"

chmod 600 "$HOME/.ssh/id_ed25519"

mkdir -p "$HOME/.trash" # Needed to get lf's trash command to work correctly

# Enable Swedish locale
if grep -q "#sv_SE.UTF-8 UTF-8" /etc/locale.gen; then
    sudo sed -i 's/#\(sv_SE.UTF-8 UTF-8\)/\1/g' /etc/locale.gen
    sudo locale-gen
fi

# Needed by waybar (keyboard-state)
sudo usermod -aG input sebelino
sudo usermod -aG docker sebelino

# Needed by libvirt (virt-manager, virt-install)
sudo usermod -aG libvirt sebelino
sudo usermod -aG kvm sebelino

# Needed to run wireshark as non-root
sudo usermod -aG wireshark sebelino

# Needed for autologin
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo cp "$scriptdir/login/autologin.conf" /etc/systemd/system/getty@tty1.service.d/autologin.conf

if ! diff -q boot/mkinitcpio.conf /etc/mkinitcpio.conf > /dev/null; then
    diff boot/mkinitcpio.conf /etc/mkinitcpio.conf || true | bat
    sudo cp boot/mkinitcpio.conf /etc/mkinitcpio.conf
    sudo mkinitcpio -P
fi

for dst in /boot/loader/entries/*; do
  fname=$(basename "$dst")
  if ! diff -q "boot/loader/entries/${fname}" "$dst" > /dev/null; then
    (diff -u "boot/loader/entries/${fname}" "$dst" || true) | bat -l diff
    sudo cp "boot/loader/entries/${fname}" "$dst"
  fi
done

# Needed to get rid of the annoying beep sound
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

# Prevents virt-manager error:
# "Requested operation is not valid: network 'default' is not active"
# You can also start it manually with `virsh net-start default`
if pgrep -x "libvirtd" > /dev/null; then
    virsh net-start --network default
fi
