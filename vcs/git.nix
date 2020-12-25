{
  enable = true;
  userName = "Sebastian Olsson";
  extraConfig = {
    rerere = {
      enabled = true;
    };
  };
  aliases = {
    pr-checkout = ''
      !f() { git fetch upstream pull/"$1"/head:PR-"$1"; git checkout PR-"$1"; }; f'';
    rewritebranch = "!f() { git rebase -i $(git merge-base master HEAD); }; f";
    diffcommit = "!f(){ git diff HEAD~$(($1 + 1)) HEAD~$1; }; f";
    diffcommitn = "!f(){ git diff HEAD~$(($1 + 1)) HEAD~$1 --name-only; }; f";
  };
  ignores = [ "gitignore/" ".ijwb" ];
}
