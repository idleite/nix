{ pkgs,  ... }: {
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    profiles.default.settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.hide-tabbar" = false;
        "zen.urlbar.behavior" = "float";
        "zen.welcome-screen.seen" = true;
    };
    policies = let
    mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    });
  in  {
        AutofillAddressEnabled = true;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableFeedbackCommands = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        ExtensionSettings = mkExtensionSettings {
#      "wappalyzer@crunchlabz.com" = "wappalyzer";
      "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
      "uBlock0@raymondhill.net" = "ublock-origin";
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
    };

    # Per-extension config via browser.storage.managed, for extensions that
    # read it — uBlock Origin does (`toOverwrite`, >= 1.33), ClearURLs does not.
    # Unlike profiles.<name>.extensions.settings (04b) it leaves the extension's
    # own storage alone, but it is a lock rather than a seed: re-asserted on
    # every start, so dashboard edits revert. Takes effect one restart late,
    # uBO caches managed storage on purpose (uAssets discussion 16939).
    "3rdparty".Extensions."{446900e4-71c2-419f-a6a7-df9c091e268b}".toOverwrite = {
        environment = {
            "base" = "https://bitwarden.harryesses.com";
        };
    };
    "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite = {
      # Entries matching `scheme://` are also subscribed as external lists.
      filterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-unbreak"
        "adguard-spyware-url"
      ];
      filters = ["||ads.example.org^"]; # dashboard: My filters
      trustedSiteDirectives = ["example.org"]; # dashboard: Trusted sites
    };
    };
  };

#   programs.zen-browser.policies = let
#     mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
#       install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
#       installation_mode = "force_installed";
#     });
#   in {
#     ExtensionSettings = mkExtensionSettings {
#       "wappalyzer@crunchlabz.com" = "wappalyzer";
#       "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
#     };

#     # Per-extension config via browser.storage.managed, for extensions that
#     # read it — uBlock Origin does (`toOverwrite`, >= 1.33), ClearURLs does not.
#     # Unlike profiles.<name>.extensions.settings (04b) it leaves the extension's
#     # own storage alone, but it is a lock rather than a seed: re-asserted on
#     # every start, so dashboard edits revert. Takes effect one restart late,
#     # uBO caches managed storage on purpose (uAssets discussion 16939).
#     "3rdparty".Extensions."uBlock0@raymondhill.net".toOverwrite = {
#       # Entries matching `scheme://` are also subscribed as external lists.
#       filterLists = [
#         "user-filters"
#         "ublock-filters"
#         "ublock-badware"
#         "ublock-privacy"
#         "ublock-unbreak"
#         "adguard-spyware-url"
#       ];
#       filters = ["||ads.example.org^"]; # dashboard: My filters
#       trustedSiteDirectives = ["example.org"]; # dashboard: Trusted sites
#     };
#   };
    programs.zen-browser.profiles.default.search = {
    force = true; # Enforce declared search engines on each rebuild
    default = "noaiddg";
    engines = {
      mynixos = {
        name = "My NixOS";
        urls = [
          {
            template = "https://mynixos.com/search?q={searchTerms}";
            params = [
              {
                name = "query";
                value = "searchTerms";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@nx"];
      };
      nixoswiki = {
        name = "NixOS Wiki";
        urls = [
          {
            template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
            params = [
              {
                name = "query";
                value = "searchTerms";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@nx"];
      };
      nixpkgs = {
        name = "nixpkgs";
        urls = [
          {
            template = "https://search.nixos.org/packages?query={searchTerms}";
            params = [
              {
                name = "query";
                value = "searchTerms";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@pkgs"];
      };
      noaiddg = {
        name = "No AI DuckDuckGo";
        urls = [
          {
            template = "https://noai.duckduckgo.com/?q={searchTerms}&noai";
            params = [
              {
                name = "query";
                value = "searchTerms";
              }
            ];
          }
        ];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = ["@noai"];
      };
      github = {
        name = "GitHub Search";
        urls = [
          {
            template = "https://github.com/search?q={searchTerms}";
          }
        ];
        definedAliases = ["@gh"];
      };
      artifacthub = {
        name = "Artifact Hub";
        urls = [
          {
            template = "https://artifacthub.io/packages/search?ts_query_web={searchTerms}";
          }
        ];
        definedAliases = ["@ah"];
      };
    };
  };
}
