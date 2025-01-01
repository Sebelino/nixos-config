* Model: Thinkpad T14s Gen 3
* Serial Number: GM-04X17V
* Type Number: 21CQ-003EMX

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

Chromium settings -> Appearance -> Show home button
Chromium settings -> On startup -> Continue where you left off

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

Install extra packages:

```bash
bash ~/nixos-config/environments/t14s/install-essentials.sh
```

Enable extra daemons after installing those packages:

```bash
bash ~/nixos-config/environments/t14s/enable-daemons.sh
```

Set up Bluetooth.
First, set the Bluetooth device in pairing mode.

```bash
bluetoothctl
> power on
> agent on
> default-agent
> scan on
> pair 5C:EB:68:71:71:E7
> trust 5C:EB:68:71:71:E7
```

Then turn off your Bluetooth device and restart it.
Since the Bluetooth device is trusted, it should connect automatically.

After installing Neovim with `init.lua`, install any LSPs you need with Mason:

```bash
nvim

:Mason
    ◍ bash-language-server bashls
    ◍ lua-language-server lua_ls
    ◍ shellcheck
    ◍ shfmt
```

Install apps (non-essential packages):

```bash
bash ~/nixos-config/environments/t14s/install-apps.sh
```

Set up Google Drive synced directory:

```bash
rclone config

No remotes found, make a new one?
n) New remote
s) Set configuration password
q) Quit config
n/s/q> n

Enter name for new remote.
name> google-drive

Storage> drive
```

Go to https://console.developers.google.com/.

Enable the Google Drive API if you haven't already.

Click `Credentials`.

Click the `rclone-gdrive-sebelino` client.

```
client_id> ...

client_secret> ...

scope> drive

service_account_file> (empty)

y/n> n

y/n> y
```

Go through Google consent screen.

```
y/n> n

y/e/d> y
```

Now rclone the directories you need:

```bash
rclone sync google-drive:/music ~/gdrive/music

# Bidirectional sync:
rclone bisync -P google-drive:/music ~/gdrive/music --resync
rclone bisync -P google-drive:/music ~/gdrive/music
```

Anki -> Tools -> Preferences -> Appearance -> Theme = Dark.

Chromium note: If you running Chromium with Wayland support, you might notice
that some keybindings for Youtube no longer work with Solemak.
Or rather, you have to switch to a new set of keybindings:

* Pause: Instead of Space (Comma), use K
* Decrease playback speed: Instead of Shift + Comma (Space + <), use Shift + Space (Space + Comma)
* Increase playback speed: Instead of Shift + Period (Space + P), use Shift + Ä (Space + Period)

Install multilib packages (Adobe Reader, Wine, etc.):

```bash
bash ~/nixos-config/environments/t14s/install-multilib-pkgs.sh
```

Set up fingerprint scanning with `swaylock`:

```bash
sudo fprintd-enroll sebelino
sudo cat /etc/pam.d/swaylock
```

```diff
- auth include login
+ auth sufficient pam_unix.so try_first_pass likeauth nullok
+ auth sufficient pam_fprintd.so
```

At the lock screen, you need to press enter before scanning your finger.

# ISO building

I have created my custom Arch Linux ISO using `archiso`, which I call
**sarch**. This is how I build it, run it in a VM, and burn it to a USB.

## Setup

Set up a version-controlled directory:

```bash
bash ~/nixos-config/environments/t14s/sarch-setup.sh
```

## Build

(Re-)build a new `.iso` file from the contents at `~/misc/iso/sarch/`:

```bash
bash ~/nixos-config/environments/t14s/sarch-rebuild.sh
```

## Run ISO in a VM

Run the ISO with QEMU to test it:

```bash
bash ~/nixos-config/environments/t14s/sarch-boot.sh
```

## Burn to USB

Write the `.iso` file to an USB plugged into your computer:

```bash
bash ~/nixos-config/environments/t14s/sarch-burn.sh
```

# Test ISO

Let's replicate the conditions for a dual-boot install in a VM.

Download a Windows 8.1 Single Language ISO here:

https://www.microsoft.com/en-us/software-download/windows8ISO

A product key may be required later. Look for one online, specifically for the
Windows 8.1 Single Language version.

Next, create a Windows 8.1 VM in virt-manager:

```bash
virt-manager &!
```

along with a disk. Give it a size of 64 GB. Install Windows 8.1 on this disk.

Inside Windows, use the Disk Management utility to shrink the disk as much as
you can.

Next, create a new VM for your Sarch ISO. Make this VM use the 64 GB disk.
Boot into Sarch. The disk should now be mounted:

```bash
lsblk

NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
loop0    7:0 0 702.1M 1 loop /run/archiso/airootfs
sr0     11:0 1 824.3M 0 rom  /run/archiso/bootmnt
vda    254:0 0 64G    0 disk
├─vda1 254:1 0 350M   0 part
└─vda2 254:2 0 32.2G  0 part
```

and you should be able to partition the disk:

```bash
parted /dev/vda
```

### Graphical glitches

I have kept seeing graphical glitches in Sway the past few months whenever
resizing windows or switching workspaces. They come in two forms:

In the more severe case, I keep seeing green glitchy boxes on my screen
whenever switching workspaces or performing other operations that causes a
sudden change in the display. This issue was short-lived, because I managed to
fix it by downgrading the kernel from linux to linux-lts. Specifically, from
Linux 6.12 to 6.6.

In the less severe case, I am seeing weird rendering glitches when resizing
windows. The glitch goes away when I focus the affected window. I have been
suffering from this issue for a couple of months now, and I have yet to find a
solution. LTS kernel downgrade did not help. iommu parameter fiddling did not
help.

### Bluetoothe idling

When I set up Bluetooth with MX Master 3,
I found that the mouse was idling after 1 second of inactivity.
I tried creating this file:

```bash
sudo nvim /etc/udev/rules.d/50-bluetooth-mouse.rules
```
```
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="10ab", ATTR{idProduct}=="9309", ATTR{power/autosuspend}="-1"
```

and it seemed to have helped.

### Installing V8 (Rstudio)

Building V8 from source using AUR takes forever or makes the computer freeze.
Instead, do the following.
In Rstudio, run:

```
Sys.setenv(DOWNLOAD_STATIC_LIBV8=1)
install.packages("V8")
```

## Boot phase (sarch)

Run the preinstalled install script:

```bash
./install.sh
```

## Troubleshooting: Keyboard sometimes gets stuck

If the keyboard appears to be stuck, check that Sway is not in Resize mode
(Mod+r). Try ESC. And try the physical Caps Lock key, because the problem seems
to be that the CTRL is pressed down (?).

## Troubleshooting: Touchpad stops working

Did the touchpad suddenly stop working? Rebooting does not help? Does the issue
persist even if you boot into Windows?

Try shutting off the computer completely (instead of rebooting). Wait for a few
seconds, then power on. This has fixed the problem on at least two occasions.

## Troubleshooting: `amdgpu: [gfxhub] page fault`

My system has begun to freeze recently. Happens about once every two days. This
started happening around the same time I started using more powerful monitors
(4K or 120Hz). `journalctl -xe --boot=-1` shows:

```
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:24 vmid:6 pasid:32779)
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:  in process chromium pid 1747 thread chromium:cs0 pid 1766
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:   in page starting at address 0x000000003b800000 from client 0x1b (UTCL2)
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00601431
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          Faulty UTCL2 client ID: SQC (data) (0xa)
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          MORE_FAULTS: 0x1
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          WALKER_ERROR: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          PERMISSION_FAULTS: 0x3
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          MAPPING_ERROR: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          RW: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu: [gfxhub] page fault (src_id:0 ring:24 vmid:6 pasid:32779)
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:  in process chromium pid 1747 thread chromium:cs0 pid 1766
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:   in page starting at address 0x000000003b800000 from client 0x1b (UTCL2)
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu: GCVM_L2_PROTECTION_FAULT_STATUS:0x00000000
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          Faulty UTCL2 client ID: CB/DB (0x0)
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          MORE_FAULTS: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          WALKER_ERROR: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          PERMISSION_FAULTS: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          MAPPING_ERROR: 0x0
Aug 19 12:54:53 t14s kernel: amdgpu 0000:33:00.0: amdgpu:          RW: 0x0
Aug 19 12:55:03 t14s kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* ring gfx_0.1.0 timeout, signaled seq=947849, emitted seq=947850
Aug 19 12:55:03 t14s kernel: [drm:amdgpu_job_timedout [amdgpu]] *ERROR* Process information: process sway pid 1375 thread sway:cs0 pid 1449
```

I followed the advice in this
[Gitlab thread](https://gitlab.freedesktop.org/drm/amd/-/issues/3067)
and tried setting the DPM performance level to `high` (from `auto`):

```
# echo "high" > /sys/class/drm/card1/device/power_dpm_force_performance_level
```

Hopefully that fixes it. If it does, I'll need to make sure this is set on
boot.
