{ pkgs, ... }: {

  home.sessionVariables = { EDITOR = "nvim"; };

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    ack
    arandr
    awscli2
    bazel_1
    chromium
    cmus
    dmenu
    feh
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
    gzdoom
    jdk8
    jq
    lm_sensors
    minikube
    mkpasswd
    nix-index # Example usage: nix-locate zlib.h
    nixfmt
    openssl
    pciutils
    pcsx2
    pinentry-curses
    python27
    python39
    ranger
    scrot
    shutter
    ssm-session-manager-plugin
    thunderbird
    tree
    unzip
    xcompmgr
    xmobar
    xorg.transset
    xorg.xdpyinfo
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

  xresources.properties = {
    "URxvt.background" = "rgba:0000/0000/0200/c800";
    "URxvt.foreground" = "white";
    "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
    "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
    "URxvt.borderless" = true;
    "URxvt.highlightColor" = "#d01018";
    "URxvt.depth" = 32; # Enables transparency together with xcompmgr -c
  };
}
