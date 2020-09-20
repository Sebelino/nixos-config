{ pkgs, ... }: {

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    ack
    arandr
    chromium
    dmenu
    feh
    git
    git-crypt
    glxinfo
    gnupg
    go
    jq
    lm_sensors
    mkpasswd
    pciutils
    pcsx2
    pinentry-curses
    thunderbird
    tree
    xcompmgr
    xmobar
    xorg.transset
    xorg.xdpyinfo
    xorg.xkbcomp
  ];

  programs = {
    bat.enable = true;
    zsh = import ./zsh.nix { pkgs = pkgs; };
    command-not-found.enable = true;
    urxvt = {
      enable = true;
      fonts = [
        "xft:Inconsolata for Powerline:size=12"
      ];
      scroll.bar.enable = false;
      scroll.lines = 20000;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = (builtins.readFile ./vimrc);
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-gitgutter
      ];
    };
  };

  xresources.properties = {
    "URxvt.background" = "rgba:0000/0000/0200/c800";
    "URxvt.foreground" = "white";
    "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
    "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
    "URxvt.borderless" = true;
    "URxvt.highlightColor" = "#d01018";
    "URxvt.depth" = 32;  # Enables transparency together with xcompmgr -c
  };
}
