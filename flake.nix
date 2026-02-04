{
  description = "pengeg's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Theming
    catppuccin.url = "github:catppuccin/nix";

    # Programs
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nix-alien.url = "github:thiagokokada/nix-alien";

    # Desktop
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Kernel/performance
    cachynix.url = "github:ByteZ1337/CachyNix";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    # Helper to create nixosSystem with common config
    mkHost = { hostname, extraModules ? [] }: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        ./hosts/${hostname}

        # Overlays
        {
          nixpkgs.overlays = [
            inputs.nix-alien.overlays.default
            inputs.cachynix.overlays.default
          ];
        }

        # Third-party NixOS modules
        inputs.catppuccin.nixosModules.catppuccin

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.pengeg = import ./modules/home;
          };
        }
      ] ++ extraModules;
    };
  in
  {
    nixosConfigurations = {
      blackbox = mkHost { hostname = "blackbox"; };
    };
  };
}
