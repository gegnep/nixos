# nixos

NixOS flake config for my personal machines.
[GitHub](https://github.com/gegnep/nixos) [GitLab](https://gitlab.com/pengeg/nixos)

## Hosts

| Host | Machine | Role |
|------|---------|------|
| **blackbox** | Ryzen 7 5800X3D, Radeon RX 9070 XT | Desktop — gaming, audio production, streaming |
| **nixpad** | ThinkPad X1 Yoga Gen 6 (i7-1185G7, Iris Xe) | Laptop — niri-only convertible with LUKS |

Each host is a `mkHost` call in `flake.nix` and a directory under `hosts/` containing `default.nix` (options) and `hardware-configuration.nix`.

## Options

Hosts configure themselves through `mySystem.*` options defined in `modules/nixos/options.nix`. This drives conditional module loading and feature gating.

### `mySystem.desktop`

- `wms` — compositors to enable on this host. Options: `hyprland`, `niri`.
- `monitors` — list of displays with name, resolution, refresh rate, position, scale, VRR flag. Consumed by both hyprland and niri configs.

### `mySystem.hardware`

- `form` — `desktop` or `laptop`. Gates the kernel (CachyOS v3 on desktop, linuxPackages_latest on laptop), swap strategy, power management stack, and scx scheduler.
- `gpu` — `amd`, `intel`, `nvidia`, or `none`. Activates the appropriate GPU module.
- `swapfile.enable` / `swapfile.sizeGB` — opt-in swapfile at `/var/lib/swapfile`.
- `peripherals.wooting` — Wooting keyboard udev rules.

### `mySystem.features`

- `gaming` — Steam extras, Proton tooling, mod managers.
- `streaming` — OBS, DaVinci Resolve, v4l2loopback kernel module.
- `audioProduction` — Bitwig, yabridge, Wine, audio plugins.
- `mcsr` — Waywall, PrismLauncher with jemalloc, Ninjabrain Bot FHS.

## Structure

<details>
<summary>Click to expand</summary>

```text
.
├── flake.nix
├── flake.lock
├── hosts/
│   ├── blackbox/                      # desktop
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── nixpad/                        # laptop (LUKS, niri-only)
│       ├── default.nix
│       └── hardware-configuration.nix
└── modules/
    ├── nixos/                         # system-level
    │   ├── default.nix
    │   ├── options.nix                # mySystem.* option definitions
    │   ├── boot.nix                   # systemd-boot, kernel (form-gated), swap
    │   ├── desktop.nix                # pipewire, ly, locale, scx (desktop-gated)
    │   ├── networking.nix             # resolved, tailscale, mullvad, NM (laptop-gated)
    │   ├── nix.nix                    # lix, substituters, nh
    │   ├── performance.nix            # sysctl tweaks, gamemode
    │   ├── programs.nix               # steam, fonts, nix-ld, appimage
    │   ├── users.nix
    │   ├── hardware/                  # gated hardware modules
    │   │   ├── default.nix            # bluetooth, TPM2
    │   │   ├── amd.nix                # amdgpu, lact, opencl
    │   │   ├── intel.nix              # intel-media-driver, iHD, compute runtime
    │   │   ├── laptop.nix             # PPD, thermald, fprintd, power tunables
    │   │   └── wooting.nix            # udev rules
    │   └── wm/
    │       ├── hyprland.nix
    │       └── niri.nix               # pulls niri-flake and xwayland-satellite
    │
    └── home/                          # home-manager
        ├── default.nix
        ├── packages.nix               # general CLI/GUI tools
        ├── desktop/
        │   ├── default.nix            # conditionally imports per-WM modules
        │   ├── common/                # compositor-agnostic
        │   │   ├── default.nix
        │   │   ├── packages.nix
        │   │   ├── services.nix       # cliphist, udiskie
        │   │   ├── theme.nix          # GTK/Qt/kvantum catppuccin
        │   │   ├── kde.nix            # dolphin + plasma-integration
        │   │   ├── noctalia.nix
        │   │   └── xdg.nix            # portals, mime, userDirs
        │   └── wm/
        │       ├── hyprland/{default.nix,binds.nix}
        │       └── niri/{default.nix,binds.nix}
        ├── programs/
        │   ├── default.nix            # feature-gated imports
        │   ├── audio.nix              # bitwig, yabridge (gated on audioProduction)
        │   ├── cli.nix
        │   ├── firefox.nix
        │   ├── gaming.nix             # steam/gamescope (gated on gaming)
        │   ├── git.nix
        │   ├── mcsr.nix               # waywall/ninbot/prism (gated on mcsr)
        │   ├── neovim.nix             # via nvf
        │   ├── obs.nix                # (gated on streaming)
        │   ├── spotify.nix            # spicetify
        │   ├── terminals.nix          # ghostty + kitty
        │   └── waywall/               # config dropped into ~/.config/waywall
        └── shell/
            ├── default.nix
            └── zsh.nix                # zsh + p10k + zplug
```

</details>

## Notable inputs

- **[niri-flake](https://github.com/sodiboo/niri-flake)** — niri compositor + declarative KDL-via-Nix
- **[nvf](https://github.com/notashelf/nvf)** — Neovim configuration framework
- **[noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)** — quickshell-based bar, universal across compositors
- **[CachyNix](https://github.com/ByteZ1337/CachyNix)** — CachyOS kernel packages (desktop only)
- **[catppuccin/nix](https://github.com/catppuccin/nix)** — theming
- **[spicetify-nix](https://github.com/Gerg-L/spicetify-nix)**
- **[NUR](https://github.com/nix-community/NUR)** — Firefox extensions

## Theming

Catppuccin Mocha Lavender across the stack. Most apps are themed via `catppuccin/nix` module toggles (btop, fzf, zathura, kitty, ghostty, lazygit, spicetify, kvantum, zathura, nvf). A few required manual work, documented in the relevant module:

- **GTK4 / libadwaita** — symlinks from the catppuccin-gtk package into `~/.config/gtk-4.0/` via `xdg.configFile` (see `modules/home/desktop/common/theme.nix`). Required because GTK4 doesn't read themes the way GTK3 does.
- **Chatterino** — theme JSON dropped via `fetchurl` (not packaged).
- **Vesktop/Discord** — one-time Catppuccin toggle in Vencord settings, not declarative.
- **Firefox** — userChrome.css with inlined hex colors via `profiles.default.settings`; content theming via Stylus + manually-imported per-site userstyles.

## Per-host notes

### blackbox
- systemd-boot, CachyOS v3 kernel, 32 GiB swapfile, scx scheduler active
- LACT for AMD GPU power/fan control
- 2560x1440@165 + 1920x1080@100 dual monitor
- Both hyprland and niri sessions available

### nixpad
- systemd-boot, mainline kernel, 16 GiB swapfile, LUKS2 on root
- Power-profiles-daemon, thermald, fprintd, fwupd, battery thresholds at 75/90
- NetworkManager (laptop-gated)
- Aggressive PCI/USB/audio runtime PM via powerManagement.powertop + modprobe options
- niri-only

## Building

```sh
# On the target host:
nh os switch

# Or from anywhere:
sudo nixos-rebuild switch --flake /path/to/flake.#<hostname>
```
