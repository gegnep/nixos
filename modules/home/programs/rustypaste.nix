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
          tmp="$(mktemp --suffix=.png)"
          trap 'rm -f "$tmp"' EXIT
          wl-paste --type image/png > "$tmp"
          url="$(rpaste "$tmp")"
          ;;
        *)
          url="$(wl-paste --no-newline | rpaste -)"
          ;;
        esac

        printf '%s' "$url" | wl-copy
        notify-send "rustypaste" "$url"
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
