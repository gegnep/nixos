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

- `gaming` — Steam extras, Proton tooling, Prism (jdk8/17/21), mod managers.
- `streaming` — OBS, DaVinci Resolve, v4l2loopback kernel module.
- `audioProduction` — Bitwig, yabridge, Wine, audio plugins.

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
│   └── nixpad/                        # laptop (LUKS)
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
        │   │   ├── nautilus.nix       # nautilus + GTK bookmarks
        │   │   ├── noctalia.nix
        │   │   └── xdg.nix            # portals, mime, userDirs
        │   └── wm/
        │       ├── hyprland/{default.nix,binds.nix}
        │       └── niri/{default.nix,binds.nix}
        ├── programs/
        │   ├── default.nix            # feature-gated imports
        │   ├── audio.nix              # bitwig, yabridge (gated on audioProduction)
        │   ├── chat.nix               # chatterino, vesktop + slack (bwrapper-sandboxed)
        │   ├── claude.nix             # claude-code, bwrapper-sandboxed (claude + claude-work)
        │   ├── cli.nix
        │   ├── codex.nix              # codex CLI, bwrapper-sandboxed
        │   ├── fastfetch/             # module + λ-styled logo
        │   ├── firefox.nix
        │   ├── gaming.nix             # steam extras, prism, mod managers (gated on gaming)
        │   ├── git.nix
        │   ├── laptop.nix             # pen/tablet + misc laptop utils
        │   ├── neovim.nix             # via nvf
        │   ├── obs.nix                # (gated on streaming)
        │   ├── spotify.nix            # spicetify
        │   ├── terminals.nix          # ghostty + alacritty
        │   └── zed.nix                # zed + sandboxed ACP agents (claude, codex)
        └── shell/
            ├── default.nix
            └── zsh.nix                # zsh + p10k (also imported by the homelab flake)
```

</details>

## Notable inputs

- **[niri-flake](https://github.com/sodiboo/niri-flake)** — niri compositor + declarative KDL-via-Nix
- **[nvf](https://github.com/notashelf/nvf)** — Neovim configuration framework
- **[noctalia-shell](https://github.com/noctalia-dev/noctalia-shell)** — quickshell-based bar, universal across compositors
- **[Chaotic-Nyx](https://github.com/chaotic-cx/nyx)** — CachyOS kernel + binary cache (desktop only)
- **[nix-bwrapper](https://github.com/Naxdy/nix-bwrapper)** — bubblewrap sandboxing (claude-code, codex, ACP agents, slack, vesktop)
- **[nirinit](https://github.com/amaanq/nirinit)** — session restore for niri
- **[catppuccin/nix](https://github.com/catppuccin/nix)** — Theming
- **[spicetify-nix](https://github.com/Gerg-L/spicetify-nix)** — Spotify Theming
- **[NUR](https://github.com/nix-community/NUR)** — Firefox extensions
- **[Millennium](https://github.com/SteamClientHomebrew/Millennium)** — Steam theming + extensions

## Automation

The homelab runs the maintenance loop for the desktop flake (`gegnep/nixos`) end to end — bump, build, serve, scan, report. The desktops never compile or evaluate anything the homelab hasn't already built.

- **flake-builder** (`services/flake-builder.nix`) — nightly timer that maintains an isolated clone of `github:gegnep/nixos`, runs `nix flake update` (all inputs), builds **both** `blackbox` and `nixpad` toplevels, and only if both succeed commits and pushes the lock (`chore: bump flake.lock (automated)`). A failed build never advances the lock — the hosts must evaluate exactly the lock the homelab built, or substitution breaks. Last successful pair of toplevels is kept as gcroots under `/var/lib/flake-builder` so `nh clean` can't evict closures before the hosts pull them. Runs at `Nice=19`/`CPUWeight=25` so nightly kernel compiles don't starve services.
- **Harmonia** (`services/buildserver.nix`) — serves the resulting store paths; the desktops list `http://homelab:5000` + the `homelab-1` key as a substituter.
- **nightly scan** — a scheduled Claude routine that runs after the bump window and reports to `gegnep/nixos` issues. It triages any open build failure first (root cause from the embedded log, snippet-ready fix commented on the issue, labeled `triaged`), then scans the config for deprecated/renamed/removed options and packages — verified against the *locked* input revs via the [mcp-nixos](https://github.com/utensils/mcp-nixos) connector (also hosted here, `services/mcp-nixos.nix`), not channel HEAD. Findings are graded Critical / Warning / Info with file:line, a ready-to-apply fix, and a source link; each run diffs against the previous scan so unchanged items carry as one-liners.

Issue labels are the state machine:

| Labels | Opened by | Meaning | Closed by |
|---|---|---|---|
| `flake-builder` + `automated` | the bump job, on failure | lock not advanced, hosts pinned to last-good; log tail embedded | the next green bump |
| ↳ + `triaged` | the scan | diagnosis + fix commented | — |
| `nightly-scan` + `automated` | the scan, daily | that night's findings report | manually (or immediately, on a clean run) |

Failure path: bump fails → `flake-builder` issue (+ ntfy push) → scan triages it that night → fix lands in the desktop repo → next bump goes green, closes the issue, Harmonia serves the new closures.

## Theming

Catppuccin Mocha Lavender across the stack. `catppuccin.autoEnable = true` themes everything the `catppuccin/nix` modules support (bat, btop, fzf, ghostty, lazygit, tmux, atuin, eza, mpv, mangohud, obs, kvantum, gtk icons, ...); spicetify and nvf theme through their own mechanisms. The exceptions, documented in the relevant module:

- **Firefox** — opted out of catppuccin/nix (it fights the managed extension set); userChrome.css with inlined hex colors via `profiles.default.settings`, content theming via Stylus + manually-imported per-site userstyles.
- **Hyprland** — opted out; manual mocha palette in `wm/hyprland` (the module currently injects a broken lua-inline block into hyprlang).
- **GTK4 / libadwaita** — symlinks from the catppuccin-gtk package into `~/.config/gtk-4.0/` via `xdg.configFile` (see `modules/home/desktop/common/theme.nix`). Required because GTK4 doesn't read themes the way GTK3 does.
- **Vesktop/Discord** — one-time Catppuccin toggle in Vencord settings, not declarative.

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
---
*portions of this configuration were developed in collaboration with [Claude](https://claude.ai); AI suggestions should never replace your own understanding of your system*
