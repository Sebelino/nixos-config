# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nixpkgs = builtins.fetchTarball {
    name = "nixos-unstable-2020-09-15";
    # Latest nixos-unstable commit hash taken from https://status.nixos.org/
    url = "https://github.com/nixos/nixpkgs/archive/441a7da8080352881bb52f85e910d8855e83fc55.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "0093drxn7blw4hay41zbqzz1vhldil5sa5p0mwaqy5dn08yn4y3q";
  };

  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "9b1b55ba0264a55add4b7b4e022bdc2832b531f6";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secrets
      (import "${home-manager}/nixos")
    ];

  # Package pinning
  nixpkgs.pkgs = import "${nixpkgs}" {
    inherit (config.nixpkgs) config;
  };

  nix.nixPath = [
    "nixpkgs=${nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  # Supposedly better for the SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    initrd.luks.devices = {
      luksroot = {
        device = "/dev/disk/by-uuid/71f99570-61ab-479a-ad2f-32c693de6951";
        preLVM = true;
        allowDiscards = true;
      };
    };

    initrd.availableKernelModules = [
      "thinkpad_acpi"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "sebelino-p43"; # Define your hostname.
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "sv_SE.UTF-8";
  };

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
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  # List services that you want to enable:

  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    openssh.allowSFTP = true;

    printing.enable = false;

    udev.packages = [
      pkgs.yubikey-personalization
      pkgs.libu2f-host
    ];

    thinkfan = {
      enable = true;
      levels = ''
        (0,     0,      60)
        (1,     60,     65)
        (2,     65,     70)
        (3,     70,     75)
        (4,     75,     80)
        (5,     80,     85)
        (7,     85,     90)
        (127,   80,     32767)
      '';
      # Entries here discovered by: find /sys/devices -type f -name "temp*_input"|sed 's/^/hwmon /g'
      # Non-working and always-zero entries discarded, as well as the one that goes from 0 to 66 when plugging in charger
      sensors = ''
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp6_input
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp3_input
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp7_input
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp4_input
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp1_input
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp5_input
        hwmon /sys/devices/platform/thinkpad_hwmon/hwmon/hwmon0/temp2_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp3_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp4_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp5_input
        hwmon /sys/devices/platform/coretemp.0/hwmon/hwmon6/temp2_input
        hwmon /sys/devices/pci0000:00/0000:00:1d.4/0000:3d:00.0/hwmon/hwmon1/temp1_input
        hwmon /sys/devices/virtual/thermal/thermal_zone3/hwmon4/temp1_input
        hwmon /sys/devices/virtual/thermal/thermal_zone4/hwmon5/temp1_input
      '';
    };

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

      extraLayouts.solemak = {
        description = "Solemak, my own variant of Colemak";
        languages = [ "eng" ];
        symbolsFile = /home/sebelino/nixos-config/xkb/solemak;
      };

      displayManager.sessionCommands = "setxkbmap solemak";

      autoRepeatDelay = 250;
      autoRepeatInterval = 20;

      # Enable touchpad support.
      libinput.enable = true;

      windowManager.xmonad.enable = true;
      windowManager.xmonad.enableContribAndExtras = true;
    };
  };

  virtualisation.docker.enable = false;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Tell certain packages to be built with pulseaudio support if available
  nixpkgs.config.pulseaudio = true;

  # Allow unfree packages system-wide for now
  nixpkgs.config.allowUnfree = true;

  users.mutableUsers = false;

  users.extraUsers.sebelino = {
    shell = pkgs.zsh;
  };

  home-manager.users.sebelino = { pkgs, ... }: {
    home.sessionVariables = {
      EDITOR = "nvim";
    };

    home.packages = with pkgs; [
      chromium
      dmenu
      feh
      git
      git-crypt
      gnupg
      jq
      lm_sensors
      mkpasswd
      pcsx2
      pinentry-curses
      thunderbird
      tree
      xmobar
      xorg.xkbcomp
    ];

    programs = {
      bat.enable = true;
      zsh = {
        enable = true;
        autocd = true;
        shellAliases = {
          # Commit (c)
          gc = "git commit --verbose";
          gca = "git commit --verbose --all";
          gcm = "git commit --message";
          gcS = "git commit -S --verbose";
          gcSa = "git commit -S --verbose --all";
          gcSm = "git commit -S --message";
          gcam = "git commit --all --message";
          gco = "git checkout";
          gcO = "git checkout --patch";
          gcf = "git commit --amend --reuse-message HEAD";
          gcSf = "git commit -S --amend --reuse-message HEAD";
          gcF = "git commit --verbose --amend";
          gcSF = "git commit -S --verbose --amend";
          gcp = "git cherry-pick --ff";
          gcP = "git cherry-pick --no-commit";
          gcr = "git revert";
          gcR = "git reset 'HEAD^'";
          gcs = "git show";
          gcl = "git-commit-lost";
          gcy = "git cherry -v --abbrev";
          gcY = "git cherry -v";
        };
      };
      urxvt = {
        enable = true;
        scroll.bar.enable = false;
        scroll.lines = 20000;
      };
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        extraConfig = "colorscheme murphy";
        plugins = with pkgs.vimPlugins; [
          vim-nix
        ];
      };
    };

    xresources.properties = {
      "URxvt.background" = "rgba:1111/1111/1111/dddd";
      "URxvt.foreground" = "white";
      "URxvt.font" = "xft:monospace:size=9";
      "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
      "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
      "URxvt.borderless" = true;
      "URxvt.highlightColor" = "#d01018";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

