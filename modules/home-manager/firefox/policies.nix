{ lib }:
let
  extensions = import ./extensions.nix { inherit lib; };
in
{
  DisableTelemetry = true;
  DisableFirefoxStudies = true;
  DisablePocket = true;
  DisableAccounts = true;
  DisableFirefoxAccounts = true;
  DisableDeveloperTools = false;
  DisableFirefoxScreenshots = true;

  EnableTrackingProtection = {
    Value = true;
    Locked = true;
    Cryptomining = true;
    Fingerprinting = true;
    Category = "strict";
  };

  AutofillAddressEnabled = false;
  AutofillCreditCardEnabled = false;
  OfferToSaveLogins = false;

  DisableAppUpdate = true;
  DontCheckDefaultBrowser = true;
  DisableSetDesktopBackground = true;

  DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
  DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
  SearchBar = "unified"; # alternative: "separate"v

  UserMessaging = {
    ExtensionRecommendations = false;
    FeatureRecommendations = false;
    SkipOnboarding = true;
    MoreFromMozilla = false;
    FirefoxLabs = false;
  };

  Homepage = {
    StartPage = "previous-session";
  };

  FirefoxHome = {
    Locked = true;
    Search = true;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Stories = false;
    SponsoredStories = false;
  };

  OverrideFirstRunPage = "";
  OverridePostUpdatePage = "";

  # TODO: DefaultDownloadDirectory = "${config.home.homeDirectory}/dlds";

  ExtensionSettings = extensions.list;
}
