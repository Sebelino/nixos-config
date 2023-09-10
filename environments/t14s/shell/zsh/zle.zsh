#!/usr/bin/env zsh

# In the terminal, typing CTRL+V with your cursor placed at the end of:
# $ gc -m "feat: XXXX YYYY ZZZZ"@
# causes the line to shrink to:
# $ gc -m "feat: @"
# where '@' is the position of your cursor.
# Useful when you reverse-search a previous 'gc -m' command and want to avoid
# deleting the extra words by tapping CTRL+w repeatedly.
_git_commit_prep() {
  line="$LBUFFER"
  parts=(${(s/:/)line})
  left_part="${parts[1]}: "
  LBUFFER='gc -m "chore: '
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
