#!/usr/bin/env zsh

_git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'

# Branch (b)
alias gbc="git checkout -b"

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
