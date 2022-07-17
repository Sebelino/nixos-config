{
  enable = true;
  userName = "Sebastian Olsson";
  userEmail = "sebelino7@gmail.com";
  extraConfig = {
    rerere = { enabled = true; };
    url."git@github.com:".insteadOf = "https://github.com/";
  };
  aliases = {
    pr-checkout = ''
      !f() { git fetch upstream pull/"$1"/head:PR-"$1"; git checkout PR-"$1"; }; f'';
    rewritebranch = "!f() { git rebase -i $(git merge-base master HEAD); }; f";
    diffcommit = "!f(){ git diff HEAD~$(($1 + 1)) HEAD~$1; }; f";
    diffcommitn = "!f(){ git diff HEAD~$(($1 + 1)) HEAD~$1 --name-only; }; f";
  };
  ignores = [ "gitignore/" ".ijwb" ];
  lfs.enable = true;
}
