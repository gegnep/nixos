{ ... }:

{
  services.flatpak = {
    enable = true;

    packages = [
      "com.github.tchx84.Flatseal"
      "com.usebottles.bottles"
      "com.github.iwalton3.jellyfin-media-player"
    ];

    uninstallUnmanaged = true;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}
