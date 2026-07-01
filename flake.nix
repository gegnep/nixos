{
  description = "pengeg's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    niri = {
      url = "github:sodiboo/niri-flake/very-refactor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    };
}
