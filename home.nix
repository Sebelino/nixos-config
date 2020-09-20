{ pkgs, ... }: {

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    ack
    chromium
    dmenu
    feh
    git
    git-crypt
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
    zsh = {
      enable = true;
      autocd = true;
      shellAliases = import ./shell-aliases.nix;
      enableAutosuggestions = true;
      initExtra = ''
        # Taken from prezto, needed by a few shell aliases
        # Log
        zstyle -s ':prezto:module:git:log:medium' format '_git_log_medium_format' \
          || _git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
        zstyle -s ':prezto:module:git:log:oneline' format '_git_log_oneline_format' \
          || _git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
        zstyle -s ':prezto:module:git:log:brief' format '_git_log_brief_format' \
          || _git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'

        # Status
        zstyle -s ':prezto:module:git:status:ignore' submodules '_git_status_ignore_submodules' \
          || _git_status_ignore_submodules='none'
      '';
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
}
