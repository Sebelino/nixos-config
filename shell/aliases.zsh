#!/usr/bin/env zsh

_git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'

_switch_hotspot() {
    HOTSPOT_NAME="Sebelino-hotspot"
    current_ssid="$(iwgetid -r)"
    if [ "$current_ssid" = "$HOTSPOT_NAME" ]; then
        nmcli connection down id Sebelino-hotspot
    else
        for i in {1..50}; do
            nmcli dev wifi connect Sebelino-hotspot && break || sleep 1
        done
    fi
}

_aws_profile_switch_sts() {
    aws sts get-caller-identity >/dev/null
    if [ "$?" -eq 255 ]; then
        aws sso login
    fi
}

_aws_profile_switch() {
    export AWS_PROFILE="$(aws configure list-profiles | fzf)"
    echo "AWS_PROFILE=\033[1;35m$AWS_PROFILE\033[m"
    _aws_profile_switch_sts &! # Takes almost a second, so run it in the background
}

_vim_fzf() {
    nvim $(fzf)
}

_github_create_pr() {
    extra_arg="$1"
    git push -u origin HEAD && \
    gh pr create --fill $1 && \
    gh pr view --web
}

_update_branch_with_trunk() {
    trunk="$(git branch -l master main | sed 's/^[* ] //')"
    this_branch="$(git rev-parse --abbrev-ref HEAD)" && \
    git checkout "$trunk" && \
    git pull --rebase && \
    git checkout "$this_branch" && \
    git rebase "$trunk" && \
    unset trunk
}

_create_branch_with_generated_name() {
    git add . && \
    git stash && \
    git checkout main && \
    git pull --rebase && \
    branch_name="$(generate_random_branch_name.sh)" && \
    git checkout -b "$branch_name" && \
    git stash pop && \
    git add . && \
    unset branch_name
}

_generate_state_moving_script() {
    terraform plan -no-color > /tmp/terraform_plan.txt && \
    cat /tmp/terraform_plan.txt | state_mover.py > /tmp/terraform_plan.txt.sh && \
    bat /tmp/terraform_plan.txt.sh
}


# Homebrewn aliases
alias cdn="cd $HOME/nixos-config"
alias nrs="sudo nixos-rebuild switch"
alias nrS="urxvt -name center_window -e sh -c 'sudo nixos-rebuild switch && echo -e \"\e[1;32mOK!\"; sleep 2' &!"
alias dup="urxvt &!"
alias kgp="kubectl get pods --all-namespaces"
alias kgpw="watch -n1 kubectl get pods --all-namespaces"
alias tfr="sudo systemctl restart thinkfan.service"
alias zat="zathura"
alias sok="find . -name "
alias gcod="gcod_fn"
alias gime="gime_fn"
alias ejc="vim ~/src/jira-cli/config.yaml"
alias nät="nmcli dev wifi"
alias näts="_switch_hotspot"
alias nätr="sudo systemctl restart NetworkManager"
alias aps='_aws_profile_switch'
alias vimf="_vim_fzf"
alias ghp="_github_create_pr"
alias ghpd="_github_create_pr --draft"
alias gbp="git branch --merged | egrep -v '(^\*|master|main|dev)' | xargs git branch -d"
alias gbt="_update_branch_with_trunk"
alias gbC="_create_branch_with_generated_name"
alias ghm="gh pr merge --auto --rebase"
alias ghe="gh pr edit"
alias tfa="terraform apply"
alias tfp="terraform plan"
alias tfi="terraform init"
alias tfd="terraform destroy"
alias tsm="terraform state mv"
alias tfg="_generate_state_moving_script"

# Neovim
alias vim="nvim"
alias vimdiff="nvim -d"

# Branch (b)
alias gb="git branch"
alias gbc="git checkout -b"

# Commit (c)
alias gc="git commit --verbose"
alias gco="git checkout"
alias gcO="git checkout --patch"
alias gcf="git commit --amend --reuse-message HEAD"
alias gcF="git commit --verbose --amend"

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
