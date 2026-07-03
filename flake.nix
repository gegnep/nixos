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

    # home module only, from the very-refactor branch: supports custom kdl
    # includes + blur config, neither of which are in main yet
    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # packages only (niri-unstable, xwayland-satellite), from main so they
    # come prebuilt from the niri-flake cachix cache
    niri-pkgs = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nirinit = {
      url = "github:amaanq/nirinit";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    millennium.url = "github:SteamClientHomebrew/Millennium/next?dir=packages/nix";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nix-bwrapper.url = "https://flakehub.com/f/Naxdy/nix-bwrapper/1.*";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
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
              ];
            }
            inputs.sops-nix.nixosModules.sops
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.chaotic.nixosModules.nyx-overlay
            inputs.chaotic.nixosModules.nyx-cache
            inputs.catppuccin.nixosModules.catppuccin
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
