{ pkgs, lib, ... }: {

  home.sessionVariables = { EDITOR = "nvim"; };

  nixpkgs.config.allowUnfree = true;

  home.packages = import ./packages-home.nix { pkgs = pkgs; };

  home.file.".ideavimrc".source = ./ideavimrc;

  programs = {
    bat.enable = true;
    zsh = import ./shell/zsh.nix { pkgs = pkgs; };
    command-not-found.enable = true;
    urxvt = import ./terminal/urxvt.nix;
    neovim = import ./editor/neovim.nix { pkgs = pkgs; };
    git = import ./vcs/git.nix;
    zathura = import ./pdfviewer/zathura.nix;
  };

  services.keybase.enable = true;

  xsession = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = lib.mkDefault windowmanager/xmonad.hs;
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
