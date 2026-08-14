{ lib, pkgs, ... }:

{
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      allowed-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # nyx-cache.chaotic.cx + key come from inputs.chaotic.nixosModules.nyx-cache
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://noctalia.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
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
    allowInsecurePredicate =
      pkg:
      lib.getName pkg == "electron" # grimoire; node-abi caps at electron 40
      || "${lib.getName pkg}-${lib.getVersion pkg}" == "ventoy-1.1.12"; # unfixed CVEs, re-review on bump
  };
}
