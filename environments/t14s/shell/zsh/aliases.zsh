#!/usr/bin/env zsh

_openssl_print_cert() {
  if [ "$#" -eq 1 ]; then
    cert="$1"
  else
    tempfile="$(mktemp)"
    echo "$(</dev/stdin)" > "$tempfile"
    cert="$tempfile"
  fi
  openssl x509 -text -noout -in "$cert"
}

_openssl_show_certs() {
  domain="$1"
  port="${2:-443}"
  openssl s_client -showcerts -servername "$domain" -connect "${domain}:${port}" < /dev/null
}

_openssl_check_expiry_time() {
  hostname="$1"
  openssl s_client -connect "$hostname:443" -servername "$hostname" -showcerts </dev/null 2>/dev/null | jc --x509-cert | jq -r '.[0].tbs_certificate.validity.not_after_iso' | cut -d 'T' -f1
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

_create_branch_with_generated_name() {
    git add . && \
    git stash && \
    git switch "$(_get_git_trunk)" && \
    git pull --rebase && \
    branch_name="$(generate_random_branch_name.sh)" && \
    git checkout -b "$branch_name" && \
    git stash pop && \
    git add . && \
    unset branch_name
}

_create_branch_with_generated_name_from_current_branch() {
    branch_name="$(generate_random_branch_name.sh)" && \
    git checkout -b "$branch_name" && \
    unset branch_name
}

_github_create_pr() {
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

# Working Copy (w)
alias gws="git status --short"
alias gwS="git status"
alias gwd="git diff --no-ext-diff"

# Custom
alias k="kubectl"
alias v="nvim"
alias tfa="terraform apply"
alias tfp="terraform plan"
alias tfi="terraform init"
alias tfd="terraform destroy"
alias cer=_openssl_print_cert
alias ces=_openssl_show_certs
alias cee=_openssl_check_expiry_time
alias nät="nmcli connection up Sebelino-hotspot"
alias gbC="_create_branch_with_generated_name"
alias gbCC="_create_branch_with_generated_name_from_current_branch"
alias ghp="_github_create_pr"
