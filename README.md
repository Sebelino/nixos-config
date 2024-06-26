# nixos-config

This is my personal nixos-config, aiming to specify the environment of my
system in detail. My NixOS setup is pretty awful at the moment, and I don't
spend nearly as much time perfecting it as I should.

## Upgrading nixpkgs

One of the things I wanted to achieve was to pin the version of nixpkgs I am
using. My intention was to make upgrades more reproducible, and prevent a bunch
of packages from being sporadically re-compiled sometimes when upgrading. I got
it working, but the steps needed to update the pinned version are pretty
awkward, so here are my personal notes for how to do it.

Update the commit and hash for nixpkgs:

```
     name = "nixos-unstable-2021-05-13";
     # Latest nixos-unstable commit hash taken from https://status.nixos.org/
     url =
-      "https://github.com/nixos/nixpkgs/archive/65d6153aec85c8cb46023f0a7248628f423ca4ee.tar.gz";
+      "https://github.com/nixos/nixpkgs/archive/fbfb79400a08bf754e32b4d4fc3f7d8f8055cf94.tar.gz";
     # Hash obtained using `nix-prefetch-url --unpack <url>`
-    sha256 = "1cjd7253c4i0wl30vs6lisgvs947775684d79l03awafx7h12kh8";
+    sha256 = "0pgyx1l1gj33g5i9kwjar7dc3sal2g14mhfljcajj8bqzzrbc3za";
   };
```

And optionally also home-manager:

```
   home-manager = builtins.fetchGit {
     url = "https://github.com/rycee/home-manager.git";
-    rev = "23769994e8f7b212d9a257799173b120ed87736b";
+    rev = "aa36e2d6b481a54b95fbddbecb76076e0f38eb89";
   };
```

Now try:

```
sudo nixos-rebuild switch --upgrade
```

If you get a build error, un-pin nixpkgs:

```
   # Package pinning
-  nixpkgs.pkgs = import "${nixpkgs}" { inherit (config.nixpkgs) config; };

   nix = {
-    nixPath =
-      [ "nixpkgs=${nixpkgs}" "nixos-config=/etc/nixos/configuration.nix" ];
```

And re-run:

```
sudo nixos-rebuild switch --upgrade
```

It should now complete successfully. Now add back those lines and re-run:

```
sudo nixos-rebuild switch --upgrade
```

Sometimes this STILL results in an error due to home-manager not being able to
be properly built due to package collisions or whatever. One thing that has
demonstrably worked has been to remove some non-essential packages before
upgrading:

```
--- a/packages-home.nix
+++ b/packages-home.nix
@@ -25,7 +25,6 @@
   file
   fluidsynth
   fzf
-  gcc
   gephi
   gettext # msgfmt
   gimp
@@ -75,7 +74,6 @@
   pcsx2
   pinentry-curses
   postman
-  ppsspp
   protonvpn-cli
   python27
   python39
```

## GPG

Needed to decrypt git-crypt encrypted files.

1. Download `gpgkeys.7z`
1. `7z x gpgkeys.7z`
1. Enter 7z passphrase
1. `gpg --import myprivkeys.asc`
1. Enter GPG passphrases
1. `gpg --import mypubkeys.asc`
1. `shred -u myprivkeys.asc mypubkeys.asc`

Now you can decrypt the files:
```bash
$ git crypt unlock
```
and download any binary blobs:
```bash
$ git lfs install
```

## Audio issues

### Bluetooth requirements

Bluetooth doesn't seem to connect automatically on Arch.
You need several packages, and you need to enable some daemons.

```
yay -S alsa-utils
yay -S bluetooth-autoconnect
yay -S bluez-utils
yay -S pulseaudio
yay -S pulseaudio-alsa
yay -S pulseaudio-bluetooth

sudo systemctl enable bluetooth-autoconnect
sudo systemctl restart bluetooth-autoconnect
systemctl --user enable pulseaudio-bluetooth-autoconnect.service
systemctl --user restart pulseaudio-bluetooth-autoconnect.service
```

Put the bluetooth device in pairing mode, then pair it like so:

```
bluetoothctl
power on
agent on
scan on
trust 5C:EB:68:71:71:E7
pair 5C:EB:68:71:71:E7
connect 5C:EB:68:71:71:E7
```

### bluetoothctl: No default controller available

Try shutting down the computer and leave it powered off for a few seconds
```bash
shutdown now
```

If you get this:
```
[bluetooth]# connect 5C:EB:68:71:71:E7
Failed to connect: org.bluez.Error.NotReady br-connection-adapter-not-powered
```
try setting
```
AutoEnable=true
```
in `/etc/bluetooth/main.conf`.

### Audio issues: HDMI sound

Sometimes, when I connect my laptop to a monitor by HDMI, the sound switches to use the monitor's audio output. That is not what I want.
Whenever that happens, I have to go to `pavucontrol` -> `Output Devices` and click on `Set as fallback` for my laptop's audio device to switch back the sound to my speaker or headphones. Sometimes I have to restart Chrome or Microsoft Teams, too. Sometimes I even have to restart `pulseaudio`:

```bash
pulseaudio --kill ; sleep 1 ; pulseaudio --start
```

I have tried making sure that both `module-switch-on-port-available` and `module-switch-on-connect` are enabled in `/etc/pulse/default.pa`.
`module-switch-on-connect` also has a `blacklist` option which may come in handy.

```
$ pacmd list-modules | grep switch
	name: <module-switch-on-port-available>
	name: <module-switch-on-connect>
		module.description = "When a sink/source is added, switch to it or conditionally switch to it"
```

However, what has helped so far has been to simply blacklist the HDMI sound in `pavucontrol` -> `Configuration`.
Simply set the Profile of the monitor device to `Off` and click `Lock card to this profile`.

![image](https://user-images.githubusercontent.com/837775/185778750-0d3142a2-f660-4dc3-ac47-be43cbd92b4b.png)

### Audio issues: Handsfree

When starting my Bluetooth headset, the default
Pulseaudio profile for it would always be set to HFP (handsfree).
I needed to go to `pavucontrol` ->  Configuration to switch it to the `A2DP
Sink` profile every time.

That is, until I found that you could fix the problem by adding
`auto_switch=false` to a line in `/etc/pulse/default.pa`:

```
  .ifexists module-bluetooth-policy.so
- load-module module-bluetooth-policy
+ load-module module-bluetooth-policy auto_switch=false
  .endif
```

[Reference.](https://askubuntu.com/questions/1205749/how-permanently-remove-or-disable-hsp-hfp-bluetooth-profile)

### Audio issues: Pipewire uses the wrong sink/source

Scenario:

* You have connected your laptop to an external monitor with USB-C
* You have plugged in a headset with USB-A
* Expected behavior: Audio should come out from your headset
* Actual behavior: Audio is coming out from your monitor speakers

This indicates that Pipewire picks the monitor speaker/mic over the headset
speaker/mic. You can confirm this by running:

```bash
$ wpctl status
Audio
 ├─ Sinks:
 │      60. Family 17h/19h HD Audio Controller Speaker + Headphones [vol: 0.50 MUTED]
 │  *  137. HP E34m G4 USB Audio Analog Stereo  [vol: 0.55]
 │     161. Jabra Evolve2 85 Analog Stereo      [vol: 0.95]
 └─ Sources:
        61. Family 17h/19h HD Audio Controller Headphones Stereo Microphone [vol: 1.00]
        62. Family 17h/19h HD Audio Controller Digital Microphone [vol: 1.00]
       120. Jabra Evolve2 85 Mono               [vol: 1.00]
    *  132. HP E34m G4 USB Audio Analog Stereo  [vol: 0.94]
```

To select the headset speaker (161 Jabra...) by default, run:

```bash
$ wpctl set-default 161
```

To select the headset microphone (120 Jabra...) by default, run:

```bash
$ wpctl set-default 120
```

These settings _should_ persist even if you unplug the device.

### Audio issues: Bluetooth headset mic does not work in Teams (Pipewire)

Go to https://webcammictest.com/check-mic.html and your headset should switch
from A2DP mode (better audio, mic disabled) to HFP mode (worse audio, mic
enabled). In the Settings of your Teams meeting, an option should appear to
turn on the Headset mic.

## Autologin

Add an override for tty1:

```
$ sudo -E systemctl edit getty@tty1.service
```

and add the following lines:

```
[Service]
ExecStart=
ExecStart=-/sbin/agetty -o '-p -f -- \\u' --noclear --autologin sebelino - $TERM

# Better include this if you have configured your system to start X11 automatically
Environment=XDG_SESSION_TYPE=x11
```

To automatically enter X11 on boot, check `.zprofile`.

## Pull Git LFS blobs

```bash
git lfs install
git lfs pull
```

## Git LFS makes push/pull slow

Git LFS makes Git operations awfully slow for some reason. It can take between
4 and 20 seconds to just do a `git push`:

```bash
GIT_TRACE=1 git push  0.04s user 0.05s system 2% cpu 4.295 total
```

You can mitigate this by passing the `--no-verify` flag:

```bash
GIT_TRACE=1 git push --no-verify  0.01s user 0.01s system 1% cpu 1.323 total
```

## Statusbar

To add Thunderbird to the list of system tray icons, in
Arch at least you can install the `systray-x-git` package.
Then restart Thunderbird and the statusbar and it should work.

![image](https://user-images.githubusercontent.com/837775/182543676-3bd27358-6cff-49f0-a912-effdb1296bf0.png)

## Kernel module madness

```bash
cat /{etc,usr/lib}/modprobe.d/*
```

## Sluggish X11

I got stuck on an issue one day after a reboot. Pretty much everything
graphical felt noticably slower than usual. Resizing windows in XMonad was
delayed, and OpenGL-heavy xscreensavers were really slow. This made me suspect
the video driver.

I got a hint after checking the errors and warnings in `~/.local/share/xorg/Xorg.0.log`.
There were a couple of errors about video drivers which I fixed
by installing `xf86-video-fbdev` and `xf86-video-vesa`.

I had a look at
[this page](https://wiki.archlinux.org/title/xorg#Driver_installation)
and installed `xf86-video-amdgpu`.
```bash
$ yay -S xf86-video-amdgpu
```
And that fixed the issue!

After fixing the issue, `xrandr` now prints:

```bash
$ xrandr --listproviders
Providers: number : 1
Provider 0: id: 0x56 cap: 0xf, Source Output, Sink Output, Source Offload, Sink Offload crtcs: 4 outputs: 4 associated providers: 0 name:Unknown AMD Radeon GPU @ pci:0000:07:00.0
```

whereas previously, `modesetting` had been present in the output instead of the
`Unknown`... part.

## `xscreensaver-demo` crashes

`xscreensaver-demo` and `xscreensaver-settings` would crash on startup with
this error:

```
xscreensaver-settings: 12:51:11: X error:
xscreensaver-settings:   Failed request: BadMatch (invalid parameter attributes)
xscreensaver-settings:   Major opcode:   42 (X_SetInputFocus)
xscreensaver-settings:   Resource id:    0xa00007
xscreensaver-settings:   Serial number:  570 / 571
```

I downgraded xscreensaver from `6.06` to `6.04` as a workaround.

## `wl-copy` pasting doesn't work

You may find that certain strings cannot be pasted if you copy them into the
clipboard using `wl-copy`. In particular, this happens for PGP messages:

```bash
$ cat sample.pgp
-----BEGIN PGP MESSAGE-----
aG95aG95aG95aG95aG95aG95aG95aG95
-----END PGP MESSAGE-----
$ cat sample.pgp | wl-copy
$ wl-paste -l
application/pgp-encrypted
```

At this point, running `wl-paste` successfully prints the message, but pressing
CTRL+SHIFT+V in Alacritty does nothing.

To remedy this, [override the MIME type](https://bbs.archlinux.org/viewtopic.php?id=283588):

```bash
$ cat sample.pgp | wl-copy -t text/plain
```

## Sins

There have been times when I have had to defile my NixOS system with dirty
hacks to work around problems in the short term. I am gathering a list of these
hacks below.

```
# Sin: Can probably be purified with system.activationScripts
# https://discourse.nixos.org/t/always-symlinking-the-latest-jdk-to-a-certain-path/3099
sudo mkdir -p /lib64
sudo ln -s /nix/store/jvjchabdmcxlwjhbiii5sy6d2hcg6z7r-glibc-2.31/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
```

```
# Sin: Needed for infra's scripts
sudo ln -s /run/current-system/sw/bin/bash /bin/bash
```

```
# Sin: Symlink /home/sebelino/.xmobarrc -> /home/sebelino/nixos-config/statusbar/xmobarrc
```

```
# Sin: Symlink /etc/nixos/configuration.nix -> /home/sebelino/nixos-config/configuration.nix
```

```
# Sin: Fn-lock not configured to be on by default
When I got a new Thinkpad, the way to e.g. increase volume was to press F3,
rather than Fn+F3. I.e. the Fn keys were "inverted". I found that this was
because "FnLock" was not on. To enable it, I needed to look for a key labeled
FnLock on my keyboard -- Esc in my case -- and press Fn+Esc. I wonder if this
default behavior is configurable in Nix.
```

```
# Sin: IntellJ plugins and keybindings are not configured in Nix -- I had to
set them up all over again.
```

```
# Sin: Symlink /home/sebelino/.config/cmus/rc -> /home/sebelino/nixos-config/cmus/rc
```

```
# Sin: ~/bin/idea-wrapped to work around Java11-in-path misconfig
```

```
# Sin: home.nix hard-codes wallpaper path to: /home/sebelino/pictures/nixos_wallpaper.png
```

```
# Sin: ln -s ~/nixos-config/display/one_screen.sh ~/bin/
# Sin: ln -s ~/nixos-config/display/two_screens.sh ~/bin/
# Sin: ln -s ~/nixos-config/display/three_screens.sh ~/bin/
```

```
# Sin: Added ~/.bazelrc
```

```
# Sin: Need to run this every time the computer restarts in order to run nrs
sudo rmmod thinkpad_acpi && sudo modprobe thinkpad_acpi && tfr
```

```
# Overcoming: ImportError: libstdc++.so.6: cannot open shared object file: No such file or directory

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(nix-build -E 'import <nixpkgs>' -A stdenv.cc.cc.lib --no-out-link)/lib python3
>>> import matplotlib
```

```
TODO:
symlink ~/.themes
symlink ~/.vimrc
symlink ~/.XCompose
symlink ~/.Xresources
symlink ~/.gitignore_global
symlink ~/.gzdoom/gzdoom.ini
```

# Sin: Symlinked ~/.ssh/id_ed25519..., known_hosts

# Sin: Symlinked ~/.config/nvim/colors

# Sin: Oh-my-zsh manual install

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

# Sin: `yay` colored output

Uncomment "Color" in `/etc/pacman.conf` to get colored output in `yay`.
