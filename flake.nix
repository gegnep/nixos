{
  description = "pengeg's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    nix-bwrapper.url = "https://flakehub.com/f/Naxdy/nix-bwrapper/1.*";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    regionlock = {
      url = "github:gegnep/regionlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grimoire = {
      # Temporary: upstream main has carried a stale pnpm-deps hash since
      # 2026-08-19, which fails the nightly build. This branch is the fix,
      # PR pending. Point back at Slush97/grimoire once it merges.
      url = "github:gegnep/grimoire/fix/nix-pnpm-deps-hash";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      mkHost =
        {
          hostname,
          extraModules ? [ ],
        }:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./hosts/${hostname}
            {
              nixpkgs.overlays = [
                inputs.nur.overlays.default
                inputs.millennium.overlays.default
                inputs.nix-bwrapper.overlays.default
                inputs.grimoire.overlays.default
              ];
            }
            inputs.sops-nix.nixosModules.sops
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.chaotic.nixosModules.nyx-overlay
            inputs.chaotic.nixosModules.nyx-cache
            inputs.catppuccin.nixosModules.catppuccin
            inputs.regionlock.nixosModules.regionlock

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                    hostOptions = config.mySystem;
                  };
                  backupFileExtension = "bak";
                  users.pengeg = import ./modules/home;
                };
              }
            )
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        blackbox = mkHost { hostname = "blackbox"; };
        nixpad = mkHost { hostname = "nixpad"; };
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
