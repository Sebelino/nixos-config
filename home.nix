{ pkgs, lib, ... }: {

  home.sessionVariables = { EDITOR = "nvim"; };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ack
    acpilight
    arandr
    awscli2
    bind # Provides dig
    buildifier
    chromium
    citrix_workspace
    cmus
    dconf
    dmenu
    docker-compose
    fceux
    feh
    ffmpeg
    file
    fluidsynth
    fzf
    gcc
    gettext # msgfmt
    git
    git-crypt
    glxinfo
    gnumake # Needed to build Bazel projects (python toolchain)
    gnupg
    go
    google-cloud-sdk
    graphviz
    gzdoom
    jdk11
    jq
    libxml2 # Needed for infra's scripts
    llvmPackages.bintools
    lm_sensors
    mariadb-client
    mednafen
    mednaffe
    minikube
    mkpasswd
    mplayer
    mpv
    ncat # Provides nmap
    nix-index # Example usage: nix-locate zlib.h
    nixfmt
    openssl
    p7zip
    pavucontrol
    pciutils
    pcsx2
    pinentry-curses
    ppsspp
    python27
    python39
    ranger
    scrot
    shutter
    ssm-session-manager-plugin
    thunderbird
    torbrowser
    transmission-gtk
    tree
    unzip
    xcompmgr
    xmobar
    xorg.transset
    xorg.xdpyinfo
    xorg.xev
    xorg.xhost # Needed for infra's scripts
    xorg.xkbcomp
    zathura
  ];

  programs = {
    bat.enable = true;
    zsh = import ./zsh.nix { pkgs = pkgs; };
    command-not-found.enable = true;
    urxvt = {
      enable = true;
      fonts = [ "xft:Inconsolata for Powerline:size=12" ];
      scroll.bar.enable = false;
      scroll.lines = 20000;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = (builtins.readFile ./vimrc);
      plugins = with pkgs.vimPlugins; [ vim-nix vim-gitgutter ];
    };
    git = {
      enable = true;
      userName = "Sebastian Olsson";
      ignores = [ "gitignore/" ];
    };
  };

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = lib.mkDefault xmonad/xmonad.hs;
    };
    initExtra = ''
      setxkbmap solemak &!
      ${pkgs.feh}/bin/feh --no-fehbg --bg-scale /home/sebelino/pictures/nixos_wallpaper.png
    '';
  };

  xresources.properties = {
    "URxvt.background" = "rgba:0000/0000/0200/c800";
    "URxvt.foreground" = "white";
    "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
    "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
    "URxvt.borderless" = true;
    "URxvt.highlightColor" = "#d01018";
    "URxvt.depth" = 32; # Enables transparency together with xcompmgr -c
    "URxvt.keysym.M-0xe5" = "perl:keyboard-select:search";
    "URxvt.perl-ext-common" =
      "default,clipboard,keyboard-select,selection-to-clipboard";
    "URxvt.perl-lib" = "/home/sebelino/nixos-config/urxvt-perl";
    "URxvt.fading" = "50";
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };
}
