#!/usr/bin/env zsh

# In the terminal, typing CTRL+V will produce:
# $ gc -m "feat: @"
# with your cursor positioned at '@'.
_git_commit_prep() {
  LBUFFER='gc -m "feat: '
  RBUFFER='"'
}
zle -N _git_commit_prep
bindkey '^v' _git_commit_prep

# ALT+U to copy the current line into clipboard
_cmd_to_clip() {
  wl-copy -n <<< $BUFFER
  BUFFER=''
}
zle -N _cmd_to_clip
bindkey '\eu' _cmd_to_clip
