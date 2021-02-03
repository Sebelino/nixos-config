{ pkgs }: with pkgs; [
  ack
  acpilight
  arandr
  awscli2
  bazel-watcher
  bind # Provides dig
  buildifier
  buildkite-agent
  buildkite-cli
  chromium
  citrix_workspace
  cmus
  dconf
  dive
  dmenu
  docker-compose
  dos2unix
  drive
  fceux
  feh
  ffmpeg
  file
  fluidsynth
  fzf
  gcc
  gephi
  gettext # msgfmt
  gimp
  git
  git-crypt
  glxinfo
  gnumake # Needed to build Bazel projects (python toolchain)
  gnupg
  go
  google-cloud-sdk
  gptfdisk
  graphviz
  gzdoom
  imagemagick
  inkscape
  jdk11
  jq
  k4dirstat
  keybase
  keybase-gui
  libxml2 # Needed for infra's scripts
  llvmPackages.bintools
  lm_sensors
  mariadb-client
  maven
  mednafen
  mednaffe
  minikube
  mkpasswd
  mplayer
  mpv
  ncat # Provides nmap
  ngrok
  nix-index # Example usage: nix-locate zlib.h
  nix-prefetch-git
  nixfmt
  openssl
  p7zip
  parted
  pavucontrol
  pciutils
  pcsx2
  pinentry-curses
  postman
  ppsspp
  python27
  python39
  ranger
  scrot
  shutter
  ssm-session-manager-plugin
  terraform_0_13
  thunderbird
  topydo
  torbrowser
  transmission-gtk
  tree
  unar # unrar replacement
  unzip
  xcompmgr
  xmobar
  xorg.transset
  xorg.xdpyinfo
  xorg.xev
  xorg.xhost # Needed for infra's scripts
  xorg.xkbcomp
  zathura
]
