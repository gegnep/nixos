# nixos

NixOS flake for my personal machines.

![alt text](https://p.pengeg.com/AjQgdvXM.png "desktop screenshot containing fastfetch")

## Hosts

| Host | Machine | Role |
|------|---------|------|
| **blackbox** | Ryzen 7 5800X3D, RX 9070 XT | Desktop — gaming, audio production, streaming. CachyOS kernel, scx, LACT. |
| **nixpad** | ThinkPad X1 Yoga Gen 6 | Laptop — LUKS2, fprintd, aggressive runtime PM. |

Each host is one `mkHost` call in `flake.nix` plus `hosts/<name>/{default.nix, hardware-configuration.nix}`. Host config is a handful of `mySystem.*` options; everything else derives from them:

```nix
mySystem = {
  desktop  = { wms = [ "niri" ]; monitors = [ ... ]; };
  hardware = { form = "desktop|laptop"; gpu = "amd|intel|nvidia|none";
               swapfile = { ... }; peripherals.wooting = bool; };
  features = { gaming; streaming; audioProduction; };          # bools
  homelab  = { cache.enable; remoteBuilder.enable; };
  backup   = { enable; paths; exclude; onCalendar; };          # restic → homelab
};
```

## Layout

<details>
<summary>Click to expand</summary>

```text
.
├── flake.nix / flake.lock
├── hosts/
│   ├── blackbox/                      # desktop
│   └── nixpad/                        # laptop (LUKS)
└── modules/
    ├── nixos/                         # system-level
    │   ├── options.nix                # mySystem.* definitions
    │   ├── boot.nix                   # systemd-boot, kernel (form-gated), swap
    │   ├── desktop.nix                # pipewire, ly, locale, scx (desktop-gated)
    │   ├── flatpak.nix                # declarative flatpaks via nix-flatpak
    │   ├── homelab.nix                # Harmonia cache + remote builder
    │   ├── networking.nix             # resolved, tailscale, mullvad, NM (laptop-gated)
    │   ├── nix.nix                    # lix, substituters, nh
    │   ├── performance.nix            # sysctl tweaks, gamemode
    │   ├── programs.nix               # steam (millennium), regionlock, fonts, nix-ld
    │   ├── restic.nix                 # backups to homelab REST server
    │   ├── secrets.nix                # sops-nix
    │   ├── users.nix
    │   ├── hardware/                  # gated: amd, intel, nvidia, laptop, wooting
    │   └── wm/niri.nix                # nixpkgs niri + nirinit session restore
    │
    └── home/                          # home-manager
        ├── packages.nix               # general CLI/GUI tools
        ├── desktop/
        │   ├── common/                # packages, services, theme, nautilus, noctalia, xdg
        │   └── wm/niri/               # config + binds
        ├── programs/
        │   ├── agent-sandbox.nix      # shared bwrapper preset for agent sandboxes
        │   ├── agents.nix             # claude + claude-work (bare), codex + opencode (sandboxed)
        │   ├── audio.nix              # bitwig, yabridge (gated on audioProduction)
        │   ├── chat.nix               # chatterino; vesktop + slack (sandboxed)
        │   ├── cli.nix
        │   ├── fastfetch/             # module + λ-styled logo
        │   ├── firefox.nix
        │   ├── gaming.nix             # steam extras, prism, mod managers (gated)
        │   ├── git.nix
        │   ├── kiro.nix               # kiro-cli (work agent), sandboxed
        │   ├── laptop.nix             # pen/tablet + misc laptop utils
        │   ├── neovim.nix             # via nvf
        │   ├── obs.nix                # (gated on streaming)
        │   ├── rustypaste.nix         # homelab pastebin client
        │   ├── spotify.nix            # spicetify
        │   ├── terminals.nix          # ghostty + alacritty
        │   ├── thunderbird.nix
        │   └── zen.nix                # zen browser (default), catppuccin + betterfox
        └── shell/zsh.nix              # zsh + p10k (also imported by the homelab flake)
```

</details>

Gating: system modules wrap `config` in `lib.mkIf`; home modules use `lib.optional` imports. AI agents: `claude`/`claude-work` run bare (per-profile `CLAUDE_CONFIG_DIR` wrappers); codex, opencode, and kiro-cli run bwrapper-sandboxed via a shared preset (`agent-sandbox.nix`), as do slack and vesktop.

## Inputs

[home-manager](https://github.com/nix-community/home-manager) · [nvf](https://github.com/notashelf/nvf) · [noctalia](https://github.com/noctalia-dev/noctalia) · [Chaotic-Nyx](https://github.com/chaotic-cx/nyx) (CachyOS kernel + cache) · [nix-bwrapper](https://github.com/Naxdy/nix-bwrapper) · [nirinit](https://github.com/amaanq/nirinit) · [sops-nix](https://github.com/Mic92/sops-nix) · [catppuccin/nix](https://github.com/catppuccin/nix) · [zen-browser](https://github.com/0xc000022070/zen-browser-flake) · [spicetify-nix](https://github.com/Gerg-L/spicetify-nix) · [nix-flatpak](https://github.com/gmodena/nix-flatpak) · [nix-index-database](https://github.com/nix-community/nix-index-database) · [NUR](https://github.com/nix-community/NUR) · [Millennium](https://github.com/SteamClientHomebrew/Millennium) · [regionlock](https://github.com/gegnep/regionlock) · [grimoire](https://github.com/Slush97/grimoire)

niri comes from nixpkgs (`programs.niri`), not a flake.

## Automation

The homelab ([gegnep/nixos-prod](https://github.com/gegnep/nixos-prod)) runs the maintenance loop: a nightly job bumps `flake.lock`, builds both host toplevels, and pushes only if both succeed; Harmonia serves the closures so the hosts substitute instead of compiling. A nightly Claude scan triages build failures and files deprecation findings as issues here. Failures never advance the lock.

## Theming

`catppuccin.autoEnable = true` covers most surfaces. Exceptions live next to their modules: Zen (flake's own catppuccin preset), Firefox (Stylus userstyles), GTK4 (manual symlinks), Vesktop (in-sandbox Vencord toggle).

## Building

```sh
nh os switch                                        # on the host
sudo nixos-rebuild switch --flake .#<hostname>      # anywhere
```

---
*portions of this configuration were developed in collaboration with [Claude](https://claude.ai); AI suggestions should never replace your own understanding of your system*
