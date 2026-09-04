{ pkgs, inputs, ... }: {
  imports = [
    inputs.zen-browser.homeModules.beta
    ./apps/zen.nix
  ];
  home.username = "harry";
  home.homeDirectory = "/home/harry";

#   programs.zen-browser = {
#     enable = true;
#     setAsDefaultBrowser = true;

#   };
#   programs.zen-browser.profiles.default.settings = {
#     /**
#     use double quotes!
#     */
#     "zen.workspaces.continue-where-left-off" = true;
#     "zen.view.compact.hide-tabbar" = false;
#     "zen.urlbar.behavior" = "float";
#     "zen.welcome-screen.seen" = true;
#   };
#     programs.zen-browser.policies = {
#     AutofillAddressEnabled = true;
#     AutofillCreditCardEnabled = false;
#     DisableAppUpdate = true;
#     DisableFeedbackCommands = true;
#     DisableFirefoxStudies = true;
#     DisablePocket = true;
#     DisableTelemetry = true;
#     DontCheckDefaultBrowser = true;
#     NoDefaultBookmarks = true;
#     OfferToSaveLogins = false;
#     EnableTrackingProtection = {
#       Value = true;
#       Locked = true;
#       Cryptomining = true;
#       Fingerprinting = true;
#     };
#   };
#     programs.zen-browser.profiles.default.search = {
#     force = true; # Enforce declared search engines on each rebuild
#     default = "noaiddg";
#     engines = {
#       mynixos = {
#         name = "My NixOS";
#         urls = [
#           {
#             template = "https://mynixos.com/search?q={searchTerms}";
#             params = [
#               {
#                 name = "query";
#                 value = "searchTerms";
#               }
#             ];
#           }
#         ];
#         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
#         definedAliases = ["@nx"];
#       };
#       noaiddg = {
#         name = "No AI DuckDuckGo";
#         urls = [
#           {
#             template = "https://noai.duckduckgo.com/?q={searchTerms}&noai";
#             params = [
#               {
#                 name = "query";
#                 value = "searchTerms";
#               }
#             ];
#           }
#         ];
#         icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
#         definedAliases = ["@noai"];
#       };
#       github = {
#         name = "GitHub Search";
#         urls = [
#           {
#             template = "https://github.com/search?q={searchTerms}";
#           }
#         ];
#         definedAliases = ["@gh"];
#       };
#     };
#   };
  # Do not change this value even if you update Home Manager versions
  home.stateVersion = "25.05"; 

  # Packages to install for this user
  home.packages = with pkgs; [
    git
    htop
  ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
    programs.git = {
        enable = true;

        extraConfig = {
            init.defaultBranch = "main";
            user.name = "Harry Esses";
            user.email = "harryessesdev@harryesses.com";
        };
    };

}
