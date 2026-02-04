{ pkgs, ... }:

{
  users.users.pengeg = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "tss"    # TPM access
      "inputs"
    ];
  };

  programs.zsh.enable = true;
}
