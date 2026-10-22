{ ... }:
{
  # nixpkgs certifi reads the base cacert package and ignores the
  # security.pki blacklist (eMudhra, CVE-2026-111943).
  # Static /etc path: a store path would change every unit on each cacert bump.
  systemd.globalEnvironment.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  environment.variables.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
}
