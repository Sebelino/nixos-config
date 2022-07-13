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
  networking.wireless.networks = {
   "Olssons-5G" = { psk = "***"; };
   "Kirijo Group-5G" = { psk = "***"; };
  };
  services.xserver.enable = true;

  services.openssh.enable = true;
  services.openssh.allowSFTP = true;
  services.openssh.permitRootLogin = "yes";

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  security.sudo.extraRules = [
    {
      users = [ "sebelino" ];
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild switch";
        options = [ "SETENV" "NOPASSWD" ];
      }];
    }
  ];

  users.users.sebelino = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.mutableUsers = true;

  users.extraUsers.sebelino = {
    shell = pkgs.zsh;
    extraGroups = [ "docker" "video" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    git-crypt
    gnupg
    pinentry
    pinentry-curses
  ];

  system.stateVersion = "21.11";
}

