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

    catppuccin.url = "github:catppuccin/nix";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";

    noctalia = {
      # temporary pin as an update on 29/03/2026 @ 22:30 EST broke it
      url = "github:noctalia-dev/noctalia-shell/d1c0374f73ea687ae33b30fe6c4257dc0995d4f3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cachynix.url = "github:ByteZ1337/CachyNix";
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
                inputs.nix-alien.overlays.default
                inputs.cachynix.overlays.default
                inputs.nur.overlays.default
              ];
            }
            inputs.catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };
                backupFileExtension = "bak";
                users.pengeg = import ./modules/home;
              };
            }
          ]
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        blackbox = mkHost { hostname = "blackbox"; };
      };
    };
}
