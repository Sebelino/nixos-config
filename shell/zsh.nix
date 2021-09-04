{ pkgs }: {
  enable = true;
  autocd = true;
  shellAliases = import ./aliases.nix;
  enableAutosuggestions = true;
  history = {
    size = 100000;
    save = 100000;
  };
  initExtra = ''
    # BEWARE: Persistent rehash -- might incur performance penalty
    # https://wiki.archlinux.org/index.php/zsh#Persistent_rehash
    # Consider replacing it with an on-demand rehash
    zstyle ':completion:*' rehash true

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

    # Alias gcod
    function gcod_fn {
        commit_sha="$1"
        git diff "$commit_sha"~1 "$commit_sha"
    }

    function gime_fn {
        filename="$1"
        find . -name "$filename"
    }
  '';
  plugins = [
    {
      name = "fast-syntax-highlighting";
      src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
    }
    {
      name = "zsh-nix-shell";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.1.0";
        sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
      };
    }
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.4.0";
        sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
      };
    }
  ];
  oh-my-zsh = {
    enable = true;
    theme = "refined";
    plugins = [ "colored-man-pages" ];
  };
}
