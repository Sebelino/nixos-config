# zenia-arch

After a fresh install of Arch on Zenia, I had to take some extra steps.

## sudo

```bash
export EDITOR=nvim
visudo
# Uncomment two lines to give sebelino sudo access
```

## Locale, lang, keymap, hostname

```bash
nvim /etc/locale.gen
locale-gen
# Uncomment 'en_US.UTF-8 UTF-8'
```

```bash
echo 'LANG="en_US.UTF-8"' | tee -a /etc/locale.conf
echo 'KEYMAP=sv-latin1' | tee -a /etc/vconsole.conf
echo 'zenia' | tee /etc/hostname
```

## Run XMonad

As `sebelino`:

```bash
git clone https://github.com/Sebelino/nixos-config
cd nixos-config
./sysconfigure.sh
nvim ~/.xinitrc  # Uncomment `set -euo pipefail` so it doesn't crash
startx
```
