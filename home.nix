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
      ${pkgs.feh}/bin/feh --no-fehbg --bg-scale /home/sebelino/nixos-config/blobs/images/nixos_wallpaper.png
    '';
  };

  xresources.properties = import ./terminal/xresources.nix;

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
  };
}
