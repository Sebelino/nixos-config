#!/usr/bin/env zsh

sebe_openssl_print_cert() {
  if [ "$#" -eq 1 ]; then
    cert="$1"
  else
    tempfile="$(mktemp)"
    echo "$(</dev/stdin)" > "$tempfile"
    cert="$tempfile"
  fi
  openssl x509 -text -noout -in "$cert"
}

sebe_openssl_check_expiry_time() {
  hostname="$1"
  openssl s_client -connect "$hostname:443" -servername "$hostname" -showcerts </dev/null 2>/dev/null | jc --x509-cert | jq -r '.[0].tbs_certificate.validity.not_after_iso' | cut -d 'T' -f1
}

sebe_update_branch_with_trunk() {
    trunk="$(git branch -l master main | sed 's/^[* ] //')"
    this_branch="$(git rev-parse --abbrev-ref HEAD)" && \
    git checkout "$trunk" && \
    git pull --rebase && \
    git checkout "$this_branch" && \
    git rebase "$trunk" && \
    unset trunk
}

_get_git_trunk() {
  if [ $(git rev-parse --verify "main" 2>/dev/null) ]; then
    echo "main"
  elif [ $(git rev-parse --verify "master" 2>/dev/null) ]; then
    echo "master"
  else
    >&2 echo "Couldn't find 'main' or 'master' branch"
  fi
}

sebe_create_branch_from_branchname() {
    branch_name="$1"
    git add . && \
    git stash && \
    git switch "$(_get_git_trunk)" && \
    git pull --rebase && \
    git switch -c "$branch_name" && \
    git stash pop && \
    git add . && \
    unset branch_name
}

sebe_create_branch_with_generated_name() {
    sebe_create_branch_from_branchname "$(generate_random_branch_name.sh)"
}

sebe_create_jira_branch_with_generated_name() {
    sebe_create_branch_from_branchname "$(generate_random_jira_branch_name.sh)"
}

sebe_create_branch_with_generated_name_from_current_branch() {
    branch_name="$(generate_random_branch_name.sh)" && \
    git checkout -b "$branch_name" && \
    unset branch_name
}

sebe_github_create_pr() {
    extra_arg="$1"
    git push -u origin HEAD && \
    gh pr create --fill $1 && \
    gh pr view --web  # Should retry here
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
alias k="kubectl"
alias v="nvim"
alias zat="zathura"
alias tfa="terraform apply"
alias tfp="terraform plan"
alias tfi="terraform init"
alias tfd="terraform destroy"
alias cer=sebe_openssl_print_cert
alias ces='bash $HOME/bin/get-tls-chain.sh'
alias cee=sebe_openssl_check_expiry_time
alias nät="nmcli connection up Sebelino-hotspot"
alias gbC=sebe_create_branch_with_generated_name
alias gbJ=sebe_create_jira_branch_with_generated_name
alias gbCC=sebe_create_branch_with_generated_name_from_current_branch
alias ghp=sebe_github_create_pr
alias gbt="sebe_update_branch_with_trunk"
alias cdn="cd $HOME/nixos-config/environments/t14s/"
alias wlc="wl-copy < "
