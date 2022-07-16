{ pkgs, lib, ... }: {

  home.sessionVariables = { EDITOR = "nvim"; };

  nixpkgs.config.allowUnfree = true;

  home.packages = import ./packages-home.nix { pkgs = pkgs; };

  home.file.".ideavimrc".source = ./editor/ideavimrc;

  programs = {
    bat.enable = true;
    zsh = import ./shell/zsh.nix { pkgs = pkgs; };
    command-not-found.enable = true;
    urxvt = import ./terminal/urxvt.nix;
    neovim = import ./editor/neovim.nix { pkgs = pkgs; };
    git = import ./vcs/git.nix;
    zathura = import ./pdfviewer/zathura.nix;
    ssh = {
      enable = true;
      userKnownHostsFile = "${ ./. + "/ssh/known_hosts" }";
      matchBlocks = {
        "github" = {
          host = "github.com";
          identityFile = "${ ./. + "/secrets/id_ed25519" }";
        };
      };
    };
    xmobar = (import ./statusbar/xmobar.nix);
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
      flameshot &!
      ${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${ ./. + "/blobs/images/nixos_wallpaper.png"}
    '';
  };

  xresources.properties = import ./terminal/xresources.nix;

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };

  home.stateVersion = "20.03";
}
