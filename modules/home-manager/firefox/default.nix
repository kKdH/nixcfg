{ pkgs, lib, config, ... }:

let
  bookmarks = import ./bookmarks.nix;
  policies = import ./policies.nix { inherit lib; };
  profileSettings = import ./profiles-settings.nix {};
  searchEngines = import ./search-engines.nix { inherit pkgs; };
in
{
  options = {
    firefox.enable = lib.mkEnableOption "Enables Firefox";
  };

  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      languagePacks = [
        "en-US"
        "de"
      ];
      nativeMessagingHosts = [
        pkgs.kdePackages.plasma-browser-integration
      ];
      package = pkgs.firefox-devedition;
      policies = policies;
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
        settings = profileSettings;
        search = {
          force = true;
          default = searchEngines.default;
          engines = searchEngines.engines;
        };
        userChrome = lib.strings.concatLines [
          (builtins.readFile (
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/MrOtherGuy/firefox-csshacks/e31863b2889655e30000b5149caf31aa74469595/chrome/hide_tabs_toolbar_v2.css";
              hash = "sha256-xP2UqInVthDB67/hU9/rY1jEYXJs+R+i1qDn3LVts6Y=";
            }
          ))
          ''
            /* hide the header in the sidebar - remove the dropdown menu and close button */
            #sidebar-header {
              display: none;
            }
          ''
        ];
      };
    };
  };
}
