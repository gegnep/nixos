{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.backup;
  host = config.networking.hostName;
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
      exclude = cfg.exclude;
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
