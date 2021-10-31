# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nixpkgs = builtins.fetchTarball {
    name = "nixos-unstable-2021-11-31";
    # Latest nixos-unstable commit hash taken from https://status.nixos.org/
    url =
      "https://github.com/nixos/nixpkgs/archive/2deb07f3ac4eeb5de1c12c4ba2911a2eb1f6ed61.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "0036sv1sc4ddf8mv8f8j9ifqzl3fhvsbri4z1kppn0f1zk6jv9yi";
  };

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "406eeec0b98903561767ce7aca311034d298d53e";
  };

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./secrets
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
        device = "/dev/disk/by-uuid/${import ./hardware-luksroot-uuid.nix}";
        preLVM = true;
        allowDiscards = true;
      };
    };

    initrd.availableKernelModules = [ "thinkpad_acpi" ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "sebelino-p43"; # Define your hostname.
    wireless.enable = true; # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;

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
    nvidia-offload
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
        command =
          "/run/current-system/sw/bin/systemctl restart thinkfan.service";
        options = [ "SETENV" "NOPASSWD" ];
      }];
    }
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

    thinkfan = {
      enable = true;
    };

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      extraLayouts.solemak = {
        description = "Solemak, my own variant of Colemak";
        languages = [ "eng" ];
        symbolsFile = /home/sebelino/nixos-config/keyboard/xkb/solemak;
      };

      extraLayouts.sesebel = {
        description = "Slightly modified variant of Swedish keyboard";
        languages = [ "eng" ];
        symbolsFile = /home/sebelino/nixos-config/keyboard/xkb/sesebel;
      };

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

      videoDrivers = [ "nvidia" ];
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

  hardware.nvidia.prime = {
    offload.enable = true;

    # See https://nixos.wiki/wiki/Nvidia for how to set these
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:60:0:0";
  };

  # Tell certain packages to be built with pulseaudio support if available
  nixpkgs.config.pulseaudio = true;

  # Allow unfree packages system-wide for now
  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

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

