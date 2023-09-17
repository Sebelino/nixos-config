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

# CTRL+H to jump back a whole word
_jump_back_whole_world() {
  # If there are no spaces to the left of the cursor, jump to the beginning
  if [[ "$LBUFFER" != *' '* ]]; then
    RBUFFER="${BUFFER}"
    LBUFFER=''
    return
  fi
  last_word="${LBUFFER##* }"
  pos_last_word="$((${#LBUFFER} - ${#last_word} - 1))"
  LBUFFER="${LBUFFER:0:${pos_last_word}}"
  RBUFFER=" ${last_word}${RBUFFER}"
}
zle -N _jump_back_whole_world
bindkey '^h' _jump_back_whole_world

# ALT+U to copy the current line into clipboard
_cmd_to_clip() {
  wl-copy -n <<< $BUFFER
  BUFFER=''
}
zle -N _cmd_to_clip
bindkey '\eu' _cmd_to_clip
