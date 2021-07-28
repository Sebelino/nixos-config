{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.useDHCP = false;
  networking.interfaces.br-52ea685912c7.useDHCP = true;
  networking.interfaces.br-56b272048747.useDHCP = true;
  networking.interfaces.br-a3eef598a427.useDHCP = true;
  networking.interfaces.br-c965a9b1d02c.useDHCP = true;
  networking.interfaces.br-fe32ddaf1b44.useDHCP = true;
  networking.interfaces.docker0.useDHCP = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.vboxnet0.useDHCP = true;
  networking.interfaces.veth5068d60.useDHCP = true;
  networking.interfaces.vethb9c8c0f.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  services.xserver.enable = true;
  system.stateVersion = "21.11";
}

