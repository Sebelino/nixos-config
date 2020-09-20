{
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
  oh-my-zsh = {
    enable = true;
    theme = "agnoster";
  };
}
