{
      enable = true;
      options = import ./zathurarc.nix;
      extraConfig = (builtins.readFile ./zathurarc);
    }
