<p align="center">
  <a href="https://nixos.org/nixos"><img src="https://nixos.org/logo/nixos-hires.png" width="500px" alt="NixOS logo" /></a>
</p>

<p align="center">
<a href="https://github.com/dan4ik605743/nix-config/actions/workflows/flake-check.yml"><img src="https://github.com/dan4ik605743/nix-config/actions/workflows/flake-check.yml/badge.svg"/></a> <a href="https://github.com/dan4ik605743/nix-config/actions/workflows/format-check.yml"><img src="https://github.com/dan4ik605743/nix-config/actions/workflows/format-check.yml/badge.svg"/></a> <a href="https://github.com/dan4ik605743/nix-config/actions/workflows/build-check.yml"><img src="https://github.com/dan4ik605743/nix-config/actions/workflows/build-check.yml/badge.svg"></a>
</p><p align="center"><a href="https://github.com/nixos/nixpkgs"><img src="https://img.shields.io/badge/NixOS-21.11-informational?style=flat.svg"/></a>
</p>

## Installation
Get the latest NixOS 21.11 image <a href="https://releases.nixos.org/?prefix=nixos/unstable/">here</a>, do your partitions (root must be mounted at `/mnt`), then run the following commands
```
# move the output file of this to hosts/ggwp/hardware-configuration.nix
nixos-generate-config --root /mnt

nix-shell -p git nixFlakes
git clone https://github.com/dan4ik605743/nix-config /etc/nixos
nix build /mnt/etc/nixos#nixosConfigurations.ggwp.config.system.build.toplevel --experimental-features "flakes nix-command" --store "/mnt"
nixos-install --root /mnt --system ./result
```

### Caveats
* You probably should replace <a href="https://github.com/dan4ik605743/nix-config/blob/master/hosts/ggwp/hardware-configuration.nix">hardware-configuration.nix</a> with your own with `nixos-generate-config`.
* You probably want to change <a href="https://github.com/dan4ik605743/nix-config/tree/master/users/dan4ik/config/neovim"> my Neovim configuration</a>.
* You should probably change the options a little for yourself.

## Description

NixOS configuration that I use daily, it contains the system-wide and home configuration, symlinked to `/etc/nixos`.

See also:
* <a href="https://github.com/nix-community/home-manager">home-manager</a>
* <a href="https://nixos.wiki/wiki/Flakes">flakes</a>
* <a href="https://github.com/dan4ik605743/nur">my NUR repo</a>

Resources and configurations I used to base on:
* <a href="https://github.com/fortuneteller2k/nix-config">fortuneteller2k/nix-config</a>
* <a href="https://github.com/hlissner/dotfiles">hlissner/dotfiles</a>
* <a href="https://nixos.wiki/wiki/Configuration_Collection">NixOS configurations Collection</a>
 
## List of dependencies <space><space><space>
* I3 (Window Manager) <space><space><space><space><space>
* Bash (Shell) <space><space><space><space><space> 
* Htop (Task Manager) <space><space><space><space><space>
* Compton (Composer) <space><space><space><space><space>
* Urxvt (Terminal) <space><space><space><space><space>
* Qutebrowser (Browser) <space><space><space><space><space>
* Polybar (Bar) <space><space><space><space><space>
* Playerctl (Playback control) <space><space><space><space><space>
* Maim (Screenshoter) <space><space><space><space><space>
* Rofi (Launcher) <space><space><space><space><space>
* Neovim (Code Editor) <space><space><space><space><space>

## Appearance

![dan4ik](assets/screenshot.png)
