These files are not (currently) related to my primary machine's Nix config, but serve as a foundation for installing NixOS on a new machine.

# Dual boot
For dual boot with Windows and Arch Linux with LUKS + LVM, carefully
following this guide did the trick:

https://gist.github.com/kylemanna/cde147d777d243b82a85e9ac16b85458

Note that this means the initramfs and vmlinuz are going to be stored
in the EFI partition, which will then be mounted at /boot.
