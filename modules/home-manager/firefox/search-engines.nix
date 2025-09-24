{ pkgs }:

{
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
    "dhl" = {
      urls = [{
        template = "https://www.dhl.de/de/privatkunden/pakete-empfangen/verfolgen.html";
        params = [
          { name = "piececode"; value = "{searchTerms}"; }
        ];
      }];
      definedAliases = [ "@dhl" ];
    };
    "hermes" = {
      urls = [{
        template = "https://www.myhermes.de/empfangen/sendungsverfolgung/sendungsinformation#{searchTerms}";
        params = [];
      }];
      definedAliases = [ "@hermes" ];
    };
  };
}
