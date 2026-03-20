{ ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "browser.startup.homepage" = "about:blank";
        "privacy.trackingprotection.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };
    };
  };
}
