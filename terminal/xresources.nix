{
  "URxvt.background" = "rgba:0000/0000/0200/c800";
  "URxvt.foreground" = "white";
  "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
  "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
  "URxvt.borderless" = true;
  "URxvt.highlightColor" = "#d01018";
  "URxvt.depth" = 32; # Enables transparency together with xcompmgr -c
  "URxvt.keysym.M-0xe5" = "perl:keyboard-select:search";
  "URxvt.perl-ext-common" =
    "default,clipboard,keyboard-select,selection-to-clipboard";
  "URxvt.perl-lib" = "/home/sebelino/nixos-config/urxvt-perl";
  "URxvt.fading" = "50";
}
