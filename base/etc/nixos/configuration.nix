{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;
  services.xserver.enable = true;
  system.stateVersion = "21.11";
}

