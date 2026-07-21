# bwrapper module, dont import
{ pkgs, lib, ... }:

{
  config = {
    app.addPkgs = with pkgs; [
      wl-clipboard
      git
      ripgrep
      fd
      jq
      curl
      neovim
      nodejs
    ];

    sockets.wayland = lib.mkDefault true;
  };

  meta = {
    name = "agent-sandbox";
    description = "Common tooling + Wayland clipboard for sandboxed AI harness'";
  };
}
