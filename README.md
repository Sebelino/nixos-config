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
TODO:
symlink ~/.themes
symlink ~/.vimrc
symlink ~/.XCompose
symlink ~/.Xresources
symlink ~/.gitignore_global
symlink ~/.gzdoom/gzdoom.ini
```
