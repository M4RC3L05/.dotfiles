{
  config,
  nixpkgsUnstable,
  utils,
}:
[
  nixpkgsUnstable.act
  nixpkgsUnstable.cascadia-code
  nixpkgsUnstable.curl
  nixpkgsUnstable.dive
  nixpkgsUnstable.docker-credential-helpers
  nixpkgsUnstable.eget
  nixpkgsUnstable.ffmpeg_7-full
  nixpkgsUnstable.kubectl
  nixpkgsUnstable.lsof
  nixpkgsUnstable.nil
  nixpkgsUnstable.nixfmt-rfc-style
  nixpkgsUnstable.q
  nixpkgsUnstable.rsync
  nixpkgsUnstable.tldr
  nixpkgsUnstable.tokei
  nixpkgsUnstable.wget
  nixpkgsUnstable.procps
  nixpkgsUnstable.hyperfine
  nixpkgsUnstable.wrk
  nixpkgsUnstable.zip
  (config.lib.nixGL.wrappers.nvidia nixpkgsUnstable.nvtopPackages.full)

  (config.lib.nixGL.wrappers.mesa (
    utils.wrap nixpkgsUnstable.youtube-music {
      env = {
        NIXOS_OZONE_WL = "1";
      };
      flags = [ "--disable-gpu" ];
    }
  ))

  (config.lib.nixGL.wrappers.mesa (
    utils.wrap nixpkgsUnstable.bitwarden-desktop {
      env = {
        NIXOS_OZONE_WL = "1";
      };
    }
  ))

  (config.lib.nixGL.wrappers.mesa (
    nixpkgsUnstable.wrapFirefox nixpkgsUnstable.firefox-unwrapped {
      extraPolicies = {
        "3rdparty" = {
          Extensions = {
            "uBlock0@raymondhill.net" = {
              adminSettings = {
                dynamicFilteringString = "* * 3p-frame block";
                userSettings = {
                  advancedUserEnabled = true;
                  cloudStorageEnabled = false;
                  dynamicFilteringEnabled = true;
                };
              };
              toOverwrite = {
                filters = [
                  "www.twitch.tv##.consent-banner.kclbMN.Layout-sc-1xcs6mc-0"
                  "www.twitch.tv##.ceAbGI.Layout-sc-1xcs6mc-0"
                ];
                filterLists = [
                  "user-filters"
                  "ublock-filters"
                  "ublock-badware"
                  "ublock-privacy"
                  "ublock-quick-fixes"
                  "ublock-abuse"
                  "ublock-unbreak"
                  "easylist"
                  "easyprivacy"
                  "urlhaus-1"
                  "plowe-0"

                  "adguard-spyware-url"
                  "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
                ];
              };
            };
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              environment = {
                base = "https://vaultwarden.gufu.duckdns.org";
              };
            };
          };
        };
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        Cookies = {
          Locked = true;
          Behavior = "reject-tracker-and-partition-foreign";
          BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";
        };
        DisableAppUpdate = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxStudies = true;
        DisableFormHistory = true;
        DisablePocket = true;
        DisableProfileImport = true;
        DisableTelemetry = true;
        DisplayBookmarksToolbar = "always";
        DNSOverHTTPS = {
          Enable = true;
          ProviderURL = "https://doh.gufu.duckdns.org/dns-query";
          Locked = true;
          ExcludedDomains = [ "gufu.duckdns.org" ];
          Fallback = false;
        };
        DontCheckDefaultBrowser = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
          EmailTracking = true;
        };
        EncryptedMediaExtensions = {
          Enabled = true;
          Locked = true;
        };
        ExtensionSettings = {
          "*" = {
            installation_mode = "blocked";
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
            updates_disabled = false;
          };
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            default_area = "navbar";
            updates_disabled = false;
          };
        };
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        HardwareAcceleration = true;
        Homepage = {
          URL = "about:home";
          Locked = true;
          StartPage = "homepage";
        };
        HttpsOnlyMode = "force_enabled";
        ManagedBookmarks = [
          {
            name = "Home";
            url = "https://home.gufu.duckdns.org";
          }
          {
            name = "Syncthing";
            url = "http://127.0.0.1:8384";
          }
          {
            name = "Home Manager - Options";
            url = "https://home-manager-options.extranix.com";
          }
          {
            name = "dnscheck.tools";
            url = "https://www.dnscheck.tools";
          }
          {
            name = "Best Similar movies";
            url = "https://bestsimilar.com";
          }
          {
            name = "Duck AI";
            url = "https://duck.ai";
          }
        ];
        NewTabPage = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        SanitizeOnShutdown = true;
        SearchSuggestEnabled = false;
        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          FirefoxLabs = false;
          MoreFromMozilla = false;
          SkipOnboarding = true;
          UrlbarInterventions = false;
        };
      };

      extraPrefs = ''
        // DNS over HTTPS
        lockPref("network.trr.mode", 3);
      '';
    }
  ))
]
