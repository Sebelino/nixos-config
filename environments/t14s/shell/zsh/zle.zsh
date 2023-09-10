#!/usr/bin/env zsh

# In the terminal, typing CTRL+V with your cursor placed at the end of:
# $ gc -m "feat: XXXX YYYY ZZZZ"@
# causes the line to shrink to:
# $ gc -m "feat: @"
# where '@' is the position of your cursor.
# Useful when you reverse-search a previous 'gc -m' command and want to avoid
# deleting the extra words by tapping CTRL+w repeatedly.
_git_commit_clear() {
  line="$LBUFFER"
  parts=(${(s/:/)line})
  left_part="${parts[1]}: "
  LBUFFER="$left_part"
  RBUFFER='"'
}
zle -N _git_commit_clear
bindkey '^v' _git_commit_clear
