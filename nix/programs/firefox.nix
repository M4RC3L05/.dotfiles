{ config, pkgs }:
{
  enable = true;
  package = config.lib.nixGL.wrappers.mesa pkgs.firefox;
  policies = {
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
  };
  profiles = {
    main = {
      id = 0;
      isDefault = true;
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Toolbar";
            toolbar = true;
            bookmarks = [
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
              {
                name = "Nixpkgs-tracker";
                url = "https://nixpkgs-tracker.ocfox.me";
              }
            ];
          }
        ];
      };
      search = {
        default = "ddg";
        force = true;
        privateDefault = "ddg";
      };
      settings = {
        # General
        ## Browser layout
        "sidebar.revamp" = true;
        "sidebar.revamp.round-content-area" = true;
        "sidebar.visibility" = "hide-sidebar";
        "sidebar.verticalTabs" = true;
        "sidebar.main.tools" = "bookmarks";

        # Home
        ## New Windows and Tabs
        "browser.startup.page" = 1;
        "browser.startup.homepage" = "about:home";
        "browser.newtabpage.enabled" = true;

        ## Firefox Home Content
        "browser.newtabpage.activity-stream.showSearch" = true;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;

        # Search
        ## Search suggestions
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.urlbar.recentsearches.featureGate" = false;

        ## Address Bar
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.engines" = false;

        # Privacy & Security
        ## Enhanced Tracking Protection
        "browser.contentblocking.category" = "strict";

        ## Cookies and Site Data
        "privacy.clearSiteData.cache" = true;
        "privacy.clearSiteData.cookiesAndStorage" = false;
        "privacy.clearSiteData.historyFormDataAndDownloads" = true;
        "privacy.clearSiteData.siteSettings" = true;

        ## Passwords
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;

        ## Autofill
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        ## History
        "browser.formfill.enable" = false;
        "places.history.enabled" = false;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown_v2.cache" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
        "privacy.clearOnShutdown.siteSettings" = true;
        "privacy.clearOnShutdown_v2.siteSettings" = true;

        ## Firefox data collection and use
        "datareporting.healthreport.uploadEnabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "datareporting.usage.uploadEnabled" = false;

        ## Website advertising preferences
        "dom.private-attribution.submission.enabled" = false;

        ## HTTPS-Only Mode
        "dom.security.https_only_mode" = true;

        ## DNS over HTTPS
        "network.trr.mode" = 3;
        "network.trr.uri" = "https://doh.gufu.duckdns.org/dns-query";
        "network.trr.excluded-domains" = "gufu.duckdns.org";

        # Extra
        ## Bookmark visibility
        "browser.toolbars.bookmarks.visibility" = "never";
        ## Encrypted media extensions
        "media.eme.enabled" = true;
        ## Firefox account
        "identity.fxaccounts.enabled" = false;
        ## Pocket
        "extensions.pocket.enabled" = false;
        ## User messaging (extension/feature recomendations, firefox labs, onboarding, url bar interventions)
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "browser.aboutwelcome.enabled" = false;
        "browser.preferences.moreFromMozilla" = false;
        "browser.preferences.experimental" = false;
      };
    };
  };
}
