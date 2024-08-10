#!/usr/bin/env zsh

# In the terminal, typing CTRL+V will produce:
# $ gc -m "feat: @"
# with your cursor positioned at '@'.
sebe_git_commit_prep() {
  LBUFFER='gc -m "feat: '
  RBUFFER='"'
}
zle -N sebe_git_commit_prep
bindkey '^v' sebe_git_commit_prep

# CTRL+H to jump back a whole word
sebe_jump_back_whole_world() {
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
zle -N sebe_jump_back_whole_world
bindkey '^h' sebe_jump_back_whole_world

# ALT+U to copy the current line into clipboard
sebe_cmd_to_clip() {
  wl-copy -n <<< $BUFFER
  BUFFER=''
}
zle -N sebe_cmd_to_clip
bindkey '\eu' sebe_cmd_to_clip

lfcd() {
    cd "$(command lf -print-last-dir "$@")"
}
bindkey -s '^o' 'lfcd\n'
bindkey -s '^n' 'lf\n'
