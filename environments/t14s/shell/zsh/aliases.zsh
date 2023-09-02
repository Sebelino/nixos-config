#!/usr/bin/env zsh

_git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'

# Neovim
alias vim="nvim"
alias vimdiff="nvim -d"

# Commit (c)
alias gc="git commit --verbose"
alias gcF="git commit --verbose --amend"

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
