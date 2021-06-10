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
