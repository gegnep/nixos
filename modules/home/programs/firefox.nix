{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFormHistory = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      NoDefaultBookmarks = true;
    };

    profiles.default = {
      isDefault = true;

      search = {
        default = "Brave";
        force = true;
        engines = {
          "Brave" = {
            urls = [{ template = "https://search.brave.com/search?q={searchTerms}"; }];
            iconUpdateURL = "https://brave.com/static-assets/images/brave-favicon.png";
            definedAliases = [ "@b" ];
          };
          "Nix Packages" = {
            urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@nix" ];
          };
          "NixOS Options" = {
            urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@opts" ];
          };
          "Google".metaData.hidden = true;
          "Bing".metaData.hidden = true;
          "eBay".metaData.hidden = true;
          "Amazon.com".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Wikipedia (en)".metaData.hidden = false;
        };
      };
      
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        firefox-color
        ublock-origin
        keepassxc-browser
        facebook-container
        multi-account-containers
        metamask
        steam-database
        csgo-trader-steam-trading
        csgofloat
        frankerfacez
      ];

      settings = {
        # --- UI ---
        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.helperApps.alwaysAsk.force" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.page" = 3; # restore previous session
        "browser.zoom.full" = false; # text-only zoom
        "browser.theme.toolbar-theme" = 0; # dark toolbar
        "browser.ml.chat.menu" = false; # disable AI chat feature

        # --- New tab page (strip everything) ---
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;

        # --- URL bar ---
        "browser.urlbar.suggest.quicksuggest.all" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.trending" = false;

        # --- Privacy ---
        "browser.contentblocking.category" = "custom";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.clearOnShutdown_v2.formdata" = true;
        "privacy.userContext.enabled" = true; # containers
        "privacy.userContext.ui.enabled" = true;
        "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;

        # --- Network privacy ---
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;

        # --- Telemetry / experiments ---
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "app.shield.optoutstudies.enabled" = false;
        "nimbus.rollouts.enabled" = false;
        "browser.discovery.enabled" = false;

        # --- Annoyances ---
        "extensions.pocket.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.formfill.enable" = false;
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        # --- DRM (needed for Netflix, Spotify web, etc.) ---
        "media.eme.enabled" = true;

        # --- Performance (AMD GPU) ---
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "layers.acceleration.force-enabled" = true;

        # --- Wayland / Hyprland ---
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        # --- Scrolling ---
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
      };
    };
  };
}
