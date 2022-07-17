{ pkgs, lib, ... }:
let
  symlink = { source, destination }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [[ ! -L "${destination}" ]]; then
        ln -s "${source}" "${destination}"
      fi
    '';
in {

  home.sessionVariables = { EDITOR = "nvim"; };

  nixpkgs.config.allowUnfree = true;

  home.packages = import ./packages-home.nix { pkgs = pkgs; };

  home.file.".ideavimrc".source = ./editor/ideavimrc;

  home.activation.solaar_config = symlink {
    source = "/nixos-base/nixos-config/keyboard/solaar/config.yaml";
    destination = "$HOME/.config/solaar/config.yaml";
  };

  home.activation.solaar_rules = symlink {
    source = "/nixos-base/nixos-config/keyboard/solaar/rules.yaml";
    destination = "$HOME/.config/solaar/rules.yaml";
  };

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

  services.dunst = {
    enable = true;
  };

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
