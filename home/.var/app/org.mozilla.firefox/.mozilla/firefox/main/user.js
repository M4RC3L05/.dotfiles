// General
user_pref("browser.places.importBookmarksHTML", true);
user_pref("browser.bookmarks.file", "~/.mozilla/firefox/main/bookmarks.html");

//// Browser layout
user_pref("sidebar.revamp", true);
user_pref("sidebar.revamp.round-content-area", true);
user_pref("sidebar.visibility", "hide-sidebar");
user_pref("sidebar.verticalTabs", true);
user_pref("sidebar.main.tools", "bookmarks");

// Home
//// New Windows and Tabs
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.enabled", true);

//// Firefox Home Content
user_pref("browser.newtabpage.activity-stream.showSearch", true);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);

// Search
//// Search suggestions
user_pref("browser.search.suggest.enabled", false);
user_pref("browser.search.suggest.enabled.private", false);
user_pref("browser.urlbar.trending.featureGate", false);
user_pref("browser.urlbar.recentsearches.featureGate", false);

//// Address Bar
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", true);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.engines", false);

// Privacy & Security
//// Enhanced Tracking Protection
user_pref("browser.contentblocking.category", "strict");
user_pref("privacy.trackingprotection.allow_list.convenience.enabled", false);

//// Cookies and Site Data
user_pref("privacy.clearSiteData.cache", true);
user_pref("privacy.clearSiteData.cookiesAndStorage", false);
user_pref("privacy.clearSiteData.historyFormDataAndDownloads", true);
user_pref("privacy.clearSiteData.siteSettings", true);

//// Passwords
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("signon.management.page.breach-alerts.enabled", false);

//// Autofill
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

//// History
user_pref("browser.formfill.enable", false);
user_pref("places.history.enabled", false);
user_pref("privacy.sanitize.sanitizeOnShutdown", true);
user_pref("privacy.clearOnShutdown.cache", true);
user_pref("privacy.clearOnShutdown_v2.cache", true);
user_pref("privacy.clearOnShutdown.downloads", true);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("privacy.clearOnShutdown.history", true);
user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", true);
user_pref("privacy.clearOnShutdown.siteSettings", true);
user_pref("privacy.clearOnShutdown_v2.siteSettings", true);

//// Firefox data collection and use
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("app.shield.optoutstudies.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
user_pref("datareporting.usage.uploadEnabled", false);

//// Website advertising preferences
user_pref("dom.private-attribution.submission.enabled", false);

//// HTTPS-Only Mode
user_pref("dom.security.https_only_mode", true);

//// DNS over HTTPS
user_pref("network.trr.mode", 3);
user_pref("network.trr.uri", "https://doh.gufu.duckdns.org/dns-query");
user_pref("network.trr.excluded-domains", "gufu.duckdns.org");

// Extra
//// Bookmark visibility
user_pref("browser.toolbars.bookmarks.visibility", "never");

//// Encrypted media extensions
user_pref("media.eme.enabled", true);

//// Firefox account
user_pref("identity.fxaccounts.enabled", false);

//// Pocket
user_pref("extensions.pocket.enabled", false);

//// User messaging (extension/feature recomendations, firefox labs, onboarding, url bar interventions)
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.preferences.experimental", false);

//// AI
user_pref("browser.ml.chat.enabled", false);
user_pref("browser.ml.chat.page.footerBadge", false);
user_pref("browser.ml.chat.page.menuBadge", false);
user_pref("browser.ml.chat.shortcuts", false);
user_pref("browser.ml.chat.shortcuts.custom", false);
user_pref("browser.ml.chat.sidebar", false);
user_pref("browser.ml.checkForMemory", false);
user_pref("browser.ml.enable", false);
user_pref("browser.ml.linkPreview.shift", false);
user_pref("browser.ml.chat.menu", false);
user_pref("browser.tabs.groups.smart.enabled", false);
user_pref("browser.ml.chat.page", false);
user_pref("browser.ml.linkPreview.enabled", false);
user_pref("extensions.ml.enabled", false);
user_pref("browser.ml.pageAssist.enabled", false);
user_pref("browser.tabs.groups.smart.userEnable", false);
