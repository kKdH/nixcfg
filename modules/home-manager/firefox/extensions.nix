{ lib }:
let
  mkExtensionPolicy = id: settings: {
    "${id}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      installation_mode = "force_installed";
    } //
    settings;
  };
in
{
  # about:debugging#/runtime/this-firefox
  list = lib.mergeAttrsList [
    (mkExtensionPolicy "plasma-browser-integration@kde.org"
      {
        default_area = "menupanel";
        private_browsing = false;
      }
    )
    (mkExtensionPolicy "keepassxc-browser@keepassxc.org"
      {
        default_area = "navbar";
        private_browsing = true;
      }
    )
    (mkExtensionPolicy "addon@darkreader.org"
      {
        default_area = "navbar";
        private_browsing = true;
      }
    )
    (mkExtensionPolicy "uBlock0@raymondhill.net"
      {
        default_area = "menupanel";
        private_browsing = true;
      }
    )
    (mkExtensionPolicy "{3c078156-979c-498b-8990-85f7987dd929}" #sidebery
      {
        default_area = "menupanel";
        private_browsing = true;
      }
    )
  ];
}
