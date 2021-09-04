{ pkgs } : {
  enable = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  extraConfig = (builtins.readFile ./vimrc);
  plugins = with pkgs.vimPlugins; [ vim-nix vim-gitgutter vim-terraform ];
}
