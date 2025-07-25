{ pkgs, lib, config, ... }:

let
  bookmarks = import ./bookmarks.nix;
in
{
  options = {
    firefox.enable = lib.mkEnableOption "Enables Firefox";
  };

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      policies = {
        # TODO: DefaultDownloadDirectory = "${config.home.homeDirectory}/dlds";
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisableDeveloperTools = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = false;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"
      };
      profiles."dev-edition-default" = {
        id = 0;
        path = "default";
      };
      profiles."default" = {
        id = 1;
        bookmarks = {
          force = true;
          settings = bookmarks;
        };
        settings = {
          "browser.contentblocking.category" = "strict"; # "standard"
          "browser.startup.homepage" = "about:blank";
          "browser.tabs.closeWindowWithLastTab" = false;
          "extensions.pocket.enabled" = false;
          "general.useragent.locale" = "en-US";
          "browser.newtabpage.pinned" = [{
            title = "NixOS";
            url = "https://nixos.org";
          }];
          "browser.translations.panelShown" = false;
          "browser.translations.enable" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "network.protocol-handler.external.mailto" = false;
           # Disable some telemetry
          "app.shield.optoutstudies.enabled" = false;
          "browser.discovery.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.ping-centre.telemetry" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.prompted" = 2;
          "toolkit.telemetry.rejected" = true;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.unifiedIsOptIn" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
        };
        search = {
          force = true;
          default = "google";
          engines = {
            "google".metaData.alias = "@g";
            "crates.io" = {
              urls = [{
                template = "https://crates.io/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@crate" ];
            };
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nix" ];
            };
            "Nix Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "channel"; value = "unstable"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@opt" ];
            };
            "Dict" = {
              urls = [{
                template = "https://www.dict.cc";
                params = [
                  { name = "s"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@dict" ];
            };
            "idealo" = {
              urls = [{
                template = "https://www.idealo.de/preisvergleich/MainSearchProductCategory.html";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                  { name = "sortKey"; value = "minPrice"; }
                ];
              }];
              definedAliases = [ "@idealo" ];
            };
            "Google Maps" = {
              urls = [{
                template = "https://www.google.com/maps/search/{searchTerms}";
                params = [];
              }];
              definedAliases = [ "@maps" ];
            };
          };
        };
#       # TODO: Add NUR to home manager.
#       # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
#       #   darkreader
#       #   privacy-badger
#       # ];
      };
    };
  };
}
