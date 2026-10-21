{ ... }:
{
  # nixpkgs certifi reads the base cacert package and ignores the
  # security.pki blacklist (eMudhra, CVE-2026-111943).
  # Static /etc path: a store path would change every unit on each cacert bump.
  systemd.globalEnvironment.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
  environment.variables.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";

  # Stopgap only if you stay on the fe13242 lock today. nixpkgs 02c087f+
  # applies these names itself, so delete this block after the bump.
  security.pki.caCertificateBlacklist = [
    "emSign ECC Root CA - G3"
    "emSign Root CA - C1"
    "emSign ECC Root CA - C3"
    "Comodo AAA Services root"
  ];
}
