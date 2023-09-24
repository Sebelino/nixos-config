export EDITOR=nvim

# Needed to sign commits
export GPG_TTY=$(tty)

# Tell xdg-desktop-portal to use xdg-desktop-portal-wlr.
# Fixes screensharing in Google Meet etc.
# https://github.com/emersion/xdg-desktop-portal-wlr/wiki/%22It-doesn't-work%22-Troubleshooting-Checklist
# https://wiki.archlinux.org/title/XDG_Desktop_Portal
export XDG_CURRENT_DESKTOP=sway

# Needed by Flameshot
export QT_QPA_PLATFORM="wayland"
export SDL_VIDEODRIVER="wayland,x11"
export _JAVA_AWT_WM_NONREPARENTING=1
