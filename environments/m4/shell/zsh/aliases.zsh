#!/usr/bin/env zsh


_get_git_trunk() {
  if [ $(git rev-parse --verify "main" 2>/dev/null) ]; then
    echo "main"
  elif [ $(git rev-parse --verify "master" 2>/dev/null) ]; then
    echo "master"
  else
    >&2 echo "Couldn't find 'main' or 'master' branch"
  fi
}
_git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'

# Branch (b)
alias gbc="git switch -c"

# Commit (c)
alias gc="git commit --verbose"
alias gcf="git commit --amend --reuse-message HEAD"
alias gcF="git commit --verbose --amend"
alias gcO="git checkout --patch"

# Fetch (f)
alias gfr="git pull --rebase"

# Index (i)
alias gia="git add"
alias giA="git add --patch"
alias gid="git diff --no-ext-diff --cached"
alias gir="git reset"

# Log (l)
alias gl="git log --topo-order --pretty=format:\"${_git_log_medium_format}\""

# Push (p)
alias gp="git push"
alias gpf="git push --force-with-lease"

# Rebase (r)
alias gr="git rebase"
alias grc="git rebase --continue"

# Stash (s)
alias gs="git stash"
alias gsp="git stash pop"

# Working Copy (w)
alias gws="git status --short"
alias gwS="git status"
alias gwd="git diff --no-ext-diff"
alias gwdn="nbdiff --ignore-outputs --ignore-metadata --ignore-details"

# List files
alias l="lsd --group-directories-first -lAv"
alias ls="lsd --group-directories-first"

# Custom
alias vim='nvim'
alias vi='nvim'
alias v="nvim"
alias cdn="cd $HOME/src/nixos-config/environments/m4/"
