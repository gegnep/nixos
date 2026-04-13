# nixos

NixOS flake config for use on my personal machines.
[GitHub](https://github.com/gegnep/nixos) [GitLab](https://gitlab.com/pengeg/nixos)

## Structure
<details>
<summary>Click to expand</summary>

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   └── blackbox/                      # desktop: Ryzen 7 5800X3D, Radeon RX 9070 XT
│       ├── default.nix                # host options
│       └── hardware-configuration.nix
└── modules/
    ├── nixos/                         # system-level
    │   ├── default.nix
    │   ├── options.nix                # custom mySystem.* options
    │   ├── boot.nix                   # systemd-boot, CachyOS kernel, swap
    │   ├── desktop.nix                # pipewire, ly, locale, shared services
    │   ├── hardware.nix               # amdgpu, bluetooth, TPM, wooting rules
    │   ├── networking.nix             # resolved, tailscale, mullvad
    │   ├── nix.nix                    # lix, caches, nh
    │   ├── performance.nix            # sysctl, gamemode
    │   ├── programs.nix               # steam, fonts, nix-ld
    │   ├── users.nix
    │   └── wm/                        # wm's gated behind mySystem.desktop.wms
    │       ├── hyprland.nix           # enable hyprland
    │       └── niri.nix               # enable niri via niri-flake & pull xwayland-satellite
    │
    └── home/                          # home-manager
        ├── default.nix
        ├── packages.nix               # general CLI/GUI tools
        ├── desktop/
        │   ├── default.nix            # conditionally imports per-WM modules
        │   ├── common/                # compositor-agnostic stuff
        │   │   ├── default.nix
        │   │   ├── packages.nix       # wl-clipboard, cliphist, etc.
        │   │   ├── services.nix       # cliphist + udiskie on graphical-session
        │   │   ├── theme.nix          # GTK/Qt/kvantum catppuccin
        │   │   ├── kde.nix            # dolphin + plasma integration bits
        │   │   ├── noctalia.nix       # shared bar/launcher/session menu
        │   │   └── xdg.nix            # portals, mime, userDirs
        │   └── wm/
        │       ├── hyprland/
        │       │   ├── default.nix    # hyprland settings
        │       │   └── binds.nix
        │       └── niri/
        │           ├── default.nix    # niri settings
        │           └── binds.nix
        ├── programs/
        │   ├── default.nix
        │   ├── audio.nix              # bitwig, yabridge, plugins
        │   ├── cli.nix                # btop, direnv, eza, fzf, mpv, zathura
        │   ├── firefox.nix
        │   ├── gaming.nix             # steam/gamescope/waywall/prismlauncher
        │   ├── git.nix
        │   ├── neovim.nix             # neovim config via nvf
        │   ├── obs.nix
        │   ├── spotify.nix            # spicetify
        │   ├── terminals.nix          # ghostty + kitty
        │   └── waywall/               # mcsr setup
        └── shell/
            ├── default.nix
            └── zsh.nix
```

</details>

## Notable Inputs
- **[niri-flake](https://github.com/sodiboo/niri-flake)** — niri compositor + declarative KDL-via-Nix config
- **[nvf](https://github.com/notashelf/nvf)** — Neovim configuration framework
- **[noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)** — quickshell-based bar
- **[CachyNix](https://github.com/ByteZ1337/CachyNix)** — CachyOS kernel packages
- **[catppuccin/nix](https://github.com/catppuccin/nix)** — theming
- **[spicetify-nix](https://github.com/Gerg-L/spicetify-nix)**
- **[NUR](https://github.com/nix-community/NUR)** — Firefox extensions

