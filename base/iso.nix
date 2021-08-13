{ config, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  # Git is needed to clone my nixos-config repository and continue the
  # bootstrapping process
  environment.systemPackages = with pkgs; [ git ];
  isoImage.contents = [{
    source = ./bootstrap.sh;
    target = "/bootstrap.sh";
  }];
}
