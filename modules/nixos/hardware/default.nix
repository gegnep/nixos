{ ... }:

{
  imports = [
    ./amd.nix
    ./intel.nix
    ./laptop.nix
    ./nvidia.nix
    ./wooting.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}
