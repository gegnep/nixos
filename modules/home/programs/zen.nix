{ inputs, pkgs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    profiles.pengeg = {
      isDefault = true;
      presets.betterfox.enable = true;
      presets.catppuccin = {
        enable = true;
        flavor = "Mocha";
        accent = "Lavender";
      };

      containersForce = true;
      containers = {
        me = {
          id = 1;
          color = "purple";
          icon = "fingerprint";
        };
        work = {
          id = 2;
          color = "blue";
          icon = "briefcase";
        };
        school = {
          id = 3;
          color = "red";
          icon = "fruit";
        };
        money = {
          id = 4;
          color = "green";
          icon = "dollar";
        };
        shopping = {
          id = 5;
          color = "yellow";
          icon = "cart";
        };
        facebook = {
          id = 6;
          color = "toolbar";
          icon = "fence";
        };
      };

      spaceRouting.defaultExternalRoute = "most-recent-space";
      spaces = {
        personal = {
          id = "e61c3aae-c7ce-4f3a-84fd-8394552a339e";
          position = 0;
          container = 1;
          icon = "🎧";
        };
        work = {
          id = "b8e7d76f-bfef-44d1-be0f-b47662dcd256";
          position = 1;
          container = 2;
          icon = "💼";
        };
      };

      mods = [
        "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs
        "cb5efa80-f1e1-43ce-8c0b-fece8462d225" # Container Halo
        "1b88a6d1-d931-45e8-b6c3-bfdca2c7e9d6" # Remove Tab X
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
        "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
      ];

      settings = {
        # --- Zen ---
        "zen.widget.linux.transparency" = false;
        "browser.tabs.allow_transparent_browser" = false;
        "widget.transparent-windows" = false;

        # --- UI ---
        "browser.aboutConfig.showWarning" = false;
        "browser.tabs.warnOnClose" = false;
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.helperApps.alwaysAsk.force" = true;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.page" = 3; # restore previous session
        "browser.zoom.full" = false; # text-only zoom

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

        # --- Annoyances ---
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

        # --- Wayland ---
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;

        # --- Scrolling ---
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        stylus
        keepassxc-browser
        steam-database
        csgo-trader-steam-trading
        csgofloat
        frankerfacez
        enhancer-for-youtube
      ];

      search = {
        default = "Brave";
        force = true;
        engines = {
          "Brave" = {
            urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
            icon = "https://brave.com/static-assets/images/brave-favicon.png";
            definedAliases = [ "@b" ];
          };
          "Nix Packages" = {
            urls = [ { template = "https://search.nixos.org/packages?query={searchTerms}"; } ];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@nix" ];
          };
          "NixOS Options" = {
            urls = [ { template = "https://search.nixos.org/options?query={searchTerms}"; } ];
            icon = "https://nixos.org/favicon.png";
            definedAliases = [ "@opts" ];
          };
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "ddg".metaData.hidden = true;
          "wikipedia".metaData.hidden = false;
        };
      };

    };
  };
}
