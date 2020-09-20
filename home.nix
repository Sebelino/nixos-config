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
    jq
    lm_sensors
    mkpasswd
    pciutils
    pcsx2
    pinentry-curses
    thunderbird
    tree
    xmobar
    xorg.xkbcomp
  ];

  programs = {
    bat.enable = true;
    zsh = import ./zsh.nix { pkgs = pkgs; };
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
      extraConfig = "colorscheme murphy";
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };
  };

  xresources.properties = {
    "URxvt.background" = "rgba:1111/1111/1111/dddd";
    "URxvt.foreground" = "white";
    "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
    "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
    "URxvt.borderless" = true;
    "URxvt.highlightColor" = "#d01018";
  };
}
