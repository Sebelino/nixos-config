# Full install guide for new system

## Live USB building phase

Steps to take to create an Arch Linux live USB to boot from.

Download latest Arch Linux ISO:

https://archlinux.org/download/

Burn Arch Linux ISO to USB:

```bash
sudo dd bs=4M if=/home/sebelino/Downloads/archlinux-2023.08.01-x86_64.iso of=/dev/disk/by-id/usb-SanDisk_Cruzer_Edge_200528454118E7E24D20-0:0 conv=fsync oflag=direct status=progress
```

Turn off Secure Boot in BIOS (F12) on the target system.

Stick the USB into the target system and boot into it.

## Boot phase

Steps to take after booting into the Arch Linux live USB:

```bash
loadkeys sv-latin1
iwctl station wlan0 scan
iwctl station wlan0 get-networks
iwctl --passphrase $wifi_passphrase station wlan0 connect $wifi_ssid
```

## Space-making phase

Make room for the new partition.

* If you want dual-boot with Windows, log in to Windows and resize the C: volume if you haven't already.
* If you want to install Linux on the whole disk, remove all partitions. But then you will have to create a new EFI partition later.

```bash
device=/dev/nvme0n1
parted "$device"
(parted) p
(parted) rm [...]
(parted) w
```

## Partitioning phase

Create the new partition.

```bash
sgdisk --new=:: "$device"
sgdisk --print "$device"
lvmroot_partition_number=5
sgdisk --change-name "${lvmroot_partition_number}:lvmroot" "$device"
lvmroot_partition="${device}p${lvmroot_partition_number}"
ls $lvmroot_partition

luks_passphrase="***"
echo "$luks_passphrase" | cryptsetup --batch-mode luksFormat "$lvmroot_partition"
echo "$luks_passphrase" | cryptsetup luksOpen "$lvmroot_partition" enc-pv

pvcreate /dev/mapper/enc-pv
vgcreate vg /dev/mapper/enc-pv
lvcreate -L 16G -n swap vg
lvcreate -l '100%FREE' -n root vg

mkfs.ext4 -L root /dev/vg/root
mkswap -L swap /dev/vg/swap

mkdir -p /mnt
mount /dev/vg/root /mnt
mkdir /mnt/boot
efi_partition_number=1
efi_partition="${device}p${efi_partition_number}"
ls $efi_partition
mount $efi_partition /mnt/boot
swapon /dev/vg/swap
```

## Installation phase

```bash
pacstrap /mnt base base-devel linux linux-firmware lvm2 networkmanager efibootmgr intel-ucode sudo neovim zsh git

genfstab -U /mnt >> /mnt/etc/fstab

# Add/change `relatime` to `noatime` for root, boot, and swap
vim /mnt/etc/fstab
```

```diff
-UUID=xxx / ext4 rw,relatime 0 1
+UUID=xxx / ext4 rw,noatime 0 1

-UUID=xxx /boot vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2
+UUID=xxx /boot vfat rw,noatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2

-UUID=xxx none swap defaults 0 0
+UUID=xxx none swap defaults,noatime 0 0
```

```bash
set | grep lvmroot > /mnt/temp.sh

arch-chroot /mnt
source temp.sh
rm temp.sh

ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

hostname="t14s"
echo "$hostname" > /etc/hostname

sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo LC_ALL= >> /etc/locale.conf

echo KEYMAP=sv-latin1 > /etc/vconsole.conf

passwd
```

```diff
-MODULES=()
+MODULES=(ext4)

-HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck)
+HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block encrypt lvm2 resume filesystems fsck)
```

```bash
mkinitcpio -P

bootctl --path=/boot install

echo default arch >> /boot/loader/loader.conf
echo timeout 5 >> /boot/loader/loader.conf

nvim /boot/loader/entries/arch.conf
```

```
title Arch Linux
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
options cryptdevice=UUID=XXX:vg root=/dev/mapper/vg-root resume=/dev/mapper/vg-swap rw intel_pstate=no_hwp
```

```bash
lvmroot_partition_uuid="$(blkid "${lvmroot_partition}" -s UUID -o value)"
sed -i "s/XXX/$lvmroot_partition_uuid/" /boot/loader/entries/arch.conf

exit
umount -R /mnt
swapoff -a
reboot
```

## Post-installation phase

Let's boot into Windows and fix the time diff.

Run with Powershell as Administrator:

```powershell
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```

The next time you boot into Windows, the time should be set correctly.

## Configuration phase

Boot into Arch Linux, decrypt the disk, and log in as root.

```bash
systemctl enable --now NetworkManager
nmtui
```

```bash
cd /tmp
git clone https://github.com/Sebelino/nixos-config
cd nixos-config/
bash ./environments/t14s/bootstrap-from-root.sh
```

Then exit and login as sebelino.

```bash
bash /tmp/nixos-config/environments/t14s/bootstrap-from-user.sh
# sebelino was added to seat group by the script above, so we need to re-login
exit
```

Start Wayland:

```bash
sway
```

Press Win + Enter to open an Alacritty terminal.

```bash
chromium &!
```

Install the Bitwarden Chrome extension.

Log in to Google.

Click on the Chrome profile and set the theme color to dark.

Install extensions:

* Hacker Vision
* Distraction Free YouTube
* New Tab Redirect
  * Grant management permission
  * Set Redirect URL to https://google.com
* uBlock Origin
* Vimium

Download `gpgkeys.7z` from Gdrive.

Import GPG keys:

```bash
bash /tmp/nixos-config/environments/t14s/install-gpg-key.sh
```

Set up `~/nixos-config/`:

```bash
bash /tmp/nixos-config/environments/t14s/install-dotfiles-repo.sh
```

Configure sound:

```bash
bash ~/nixos-config/environments/t14s/install-sound.sh
```

Run symlinks:

```bash
bash ~/nixos-config/environments/t14s/sysconfigure.sh
```
