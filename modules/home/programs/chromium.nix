{ pkgs, ... }:

{
  # Secondary browser: one-off testing, work sites that break on Gecko,
  # and Claude in Chrome automation. Zen stays default.
  programs.chromium = {
    enable = true;
    package = pkgs.chromium;

    commandLineArgs = [
      "--ozone-platform-hint=auto"
      "--password-store=gnome-libsecret"
    ];

    extensions = [
      { id = "fcoeoabgfenejglbffodgkkbkcdhcgfn"; } # Claude (Claude in Chrome)
      { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
      { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC-Browser
    ];

    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}
