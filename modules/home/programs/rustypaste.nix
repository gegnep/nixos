{ pkgs, osConfig, ... }:

let
  tomlFormat = pkgs.formats.toml { };

  paste-clip = pkgs.writeShellApplication {
    name = "paste-clip";
    runtimeInputs = with pkgs; [
      rustypaste-cli
      wl-clipboard
      libnotify
    ];
    text = ''
      types="$(wl-paste --list-types)"

      case "$types" in
        *image/png*)
          url="$(wl-paste --type image/png | rpaste -n "clip-$(date +%s).png" - 2>&1)" || true
          ;;
        *)
          url="$(wl-paste --no-newline | rpaste - 2>&1)" || true
          ;;
      esac

      case "$url" in
        http*)
          printf '%s' "$url" | wl-copy
          notify-send "rustypaste" "$url"
          ;;
        *)
          notify-send -u critical "rustypaste failed" "''${url:-empty output}"
          exit 1
          ;;
      esac
    '';
  };
in
{
  home.packages = [
    pkgs.rustypaste-cli
    paste-clip
  ];

  xdg.configFile."rustypaste/config.toml".source = tomlFormat.generate "rustypaste-cli-config" {
    server = {
      address = "https://p.pengeg.com";
      auth_token_file = osConfig.sops.secrets.rustypaste-auth-token.path;
    };
    paste = { };
  };
}
