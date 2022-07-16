# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nixpkgs = builtins.fetchTarball {
    name = "nixos-unstable-2022-07-16";
    # Latest nixos-unstable commit hash taken from https://status.nixos.org/
    url =
      "https://github.com/nixos/nixpkgs/archive/c06d5fa9c605d143b15cafdbbb61c7c95388d76e.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "04fmbldsacmb8wba825didq1sj3r9na24ff3h993nimjav5mp4pv";
  };

  home-manager = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/4c5106ed0f3168ff2df21b646aef67e86cbfc11c.tar.gz";
    sha256 = "0r6hmz68mlir68jk499yii7g2qprxdn76i3bgky6qxsy8vz78mgi";
  };

  environment = (import ./environments/zenia);
in {
  imports = [ # Include the results of the hardware scan.
    environment.hardware_configuration
    (import "${home-manager}/nixos")
  ];

  # Package pinning
  nixpkgs.pkgs = import "${nixpkgs}" { inherit (config.nixpkgs) config; };

  nix = {
    nixPath =
      [ "nixpkgs=${nixpkgs}" "nixos-config=/etc/nixos/configuration.nix" ];
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.systemd-boot.configurationLimit = 100;
    loader.timeout = 5;

    initrd.luks.devices = {
      luksroot = {
        device = "/dev/disk/by-uuid/${import ./environments/zenia/hardware-luksroot-uuid.nix}";
        preLVM = true;
        allowDiscards = true;
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = environment.hostName;
    wireless = {
      enable = true; # Enables wireless support via wpa_supplicant.
      networks = (import ./secrets/wifi.nix);
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;

    nameservers = [ "8.8.8.8" ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = { LC_TIME = "sv_SE.UTF-8"; };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    slack
    wget
    xscreensaver
  ];

  environment.homeBinInPath = true;

  fonts.fonts = with pkgs; [ inconsolata powerline-fonts ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  programs.ssh = { startAgent = true; };

  security.sudo.extraRules = [
    {
      users = [ "sebelino" ];
      commands = [{
        command = "/run/current-system/sw/bin/nixos-rebuild switch";
        options = [ "SETENV" "NOPASSWD" ];
      }];
    }
  ];

  # List services that you want to enable:

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    openssh.allowSFTP = true;

    printing.enable = false;

    blueman.enable = true;

    udev.packages = [ pkgs.yubikey-personalization pkgs.libu2f-host ];

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      extraLayouts = (import ./keyboard/layouts.nix);

      displayManager.autoLogin = {
        enable = true;
        user = "sebelino";
      };

      displayManager.sessionCommands = ''
        xcompmgr &!
      '';

      autoRepeatDelay = 250;
      autoRepeatInterval = 20;

      # Enable touchpad support.
      libinput.enable = true;

      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Needed to get e.g. USB working in guest OS
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    # Allows Bluetooth audio devices to be used with PulseAudio
    package = pkgs.pulseaudioFull;
  };

  hardware.bluetooth.enable = true;

  # Allow brightness control via xbacklight from users in the `video` group.
  hardware.acpilight.enable = true;

  # Tell certain packages to be built with pulseaudio support if available
  nixpkgs.config.pulseaudio = true;

  # Allow unfree packages system-wide for now
  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

  users.users.sebelino = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" ];
    hashedPassword = (import ./secrets/passwords.nix ).sebelino;
  };

  users.users.root.hashedPassword = (import ./secrets/passwords.nix).root;

  users.extraUsers.sebelino = {
    shell = pkgs.zsh;
    extraGroups = [ "docker" "video" ];
  };

  users.extraGroups.vboxusers.members = [ "sebelino" ];

  home-manager.users.sebelino = import ./home.nix;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

