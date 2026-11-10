{
  description = "pengeg's NixOS configuration";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "https://flakehub.com/f/Mic92/sops-nix/0.1.*";
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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
      url = "https://flakehub.com/f/chaotic-cx/nyx/0.1.*";
      inputs.home-manager.follows = "home-manager";
    };

    nix-bwrapper.url = "https://flakehub.com/f/Naxdy/nix-bwrapper/1.*";
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/*";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    regionlock = {
      url = "github:gegnep/regionlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grimoire = {
      url = "github:Slush97/grimoire";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";
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
                inputs.nix-bwrapper.overlays.default
                inputs.grimoire.overlays.default
                inputs.nix-vscode-extensions.overlays.default
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
