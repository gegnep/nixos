{ pkgs, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cache.creepy.sh/cachyos"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cachyos:cm+GC47yVJ6nd6tIQDx0qlCfWnxyJv3fL/rWr7FDSSg="
      ];
    };

    optimise = {
      automatic = true;
      dates = [ "daily" ];
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 3d --keep 3";
    };
    flake = "/home/pengeg/nixos";
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [ "ventoy-1.1.10" ];
  };
}
