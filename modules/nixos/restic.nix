{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.backup;
  host = config.networking.hostName;
  commonExcludes = [
    "/home/pengeg/.cache"
    "/home/pengeg/downloads"
    "/home/pengeg/Downloads"
    "/home/pengeg/.cargo"
    "/home/pengeg/.npm"
    "/home/pengeg/.zplug"
    "/home/pengeg/.compose-cache"
    "/home/pengeg/.java"
    "/home/pengeg/.local/share/Trash"
    "/home/pengeg/.local/share/pnpm"
    "**/.direnv"
    "**/node_modules"
    # electron cache dirs inside otherwise-kept .config apps
    "/home/pengeg/.config/*/Cache"
    "/home/pengeg/.config/*/Code Cache"
    "/home/pengeg/.config/*/GPUCache"
    "/home/pengeg/.config/*/Service Worker"
    # chat sandboxes are server-synced; claude sandboxes stay (minus caches)
    "/home/pengeg/.bwrapper/vesktop"
    "/home/pengeg/.bwrapper/slack"
    "/home/pengeg/.bwrapper/*/.cache"
    "/home/pengeg/.bwrapper/*/.npm"
  ];
in
{
  config = lib.mkIf cfg.enable {
    # URL embeds the REST auth password; password file is repo encryption.
    sops.secrets."restic-repo-url-${host}" = { };
    sops.secrets."restic-repo-password-${host}" = { };

    services.restic.backups.homelab = {
      repositoryFile = config.sops.secrets."restic-repo-url-${host}".path;
      passwordFile = config.sops.secrets."restic-repo-password-${host}".path;
      initialize = true;
      inhibitsSleep = true; # don't let nixpad suspend mid-run
      paths = cfg.paths;
      exclude = commonExcludes ++ cfg.exclude;
      timerConfig = {
        OnCalendar = cfg.onCalendar;
        Persistent = true; # machine off at 23:00 UTC → runs on next boot
        RandomizedDelaySec = "15min";
      };
      # No pruneOpts: server is append-only, retention runs homelab-side.
    };

    # Failure alert to the homelab ntfy (resolves via networking.hosts + Caddy).
    systemd.services."restic-backups-homelab".onFailure = [ "notify-restic-fail.service" ];
    systemd.services.notify-restic-fail = {
      description = "Notify ntfy that the homelab backup failed";
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.curl}/bin/curl -fsS \
          -H "Title: restic backup FAILED on ${host}" \
          -H "Priority: high" \
          -H "Tags: rotating_light,floppy_disk" \
          -d "Push to homelab failed. Check: journalctl -u restic-backups-homelab" \
          http://ntfy.homelab/homelab-alerts >/dev/null || true
      '';
    };
  };
}
