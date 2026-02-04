{ ... }:

{
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;

    "net.core.netdev_max_backlog" = 16384;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general.rencie = 10;
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };
}
