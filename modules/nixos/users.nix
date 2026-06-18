{ pkgs, ... }:

{
  users.users.pengeg = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "tss" # TPM access
      "input"
      "audio"
      "video"
    ];
  };

  programs.zsh.enable = true;
}
