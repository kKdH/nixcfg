# Note:
# To find the id of an extension open: about:debugging#/runtime/this-firefox
#
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
  list = lib.mergeAttrsList [
    (mkExtensionPolicy "plasma-browser-integration@kde.org"
      {
        default_area = "menupanel";
        private_browsing = false;
      }
    )
    # (mkExtensionPolicy "keepassxc-browser@keepassxc.org"
    #   {
    #     default_area = "navbar";
    #     private_browsing = true;
    #   }
    # )
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
        default_area = "navbar";
        private_browsing = true;
      }
    )
    (mkExtensionPolicy "{78272b6fa58f4a1abaac99321d503a20@proton.me}" # Proton Pass
      {
        default_area = "navbar";
        private_browsing = true;
      }
    )
    (mkExtensionPolicy "{firefox@tampermonkey.net}" # Proton Pass
      {
        default_area = "navbar";
        private_browsing = false;
      }
    )
  ];
}
