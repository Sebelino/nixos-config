{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices = {
      lvmroot = {
        device = "/dev/disk/by-uuid/${import ./hardware-lvmroot-uuid.nix}";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };

  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.wireless.enable = true;
  services.xserver.enable = true;
  system.stateVersion = "21.11";
}

