{
  lib,
  stdenvNoCC,
  udevCheckHook,
  pkgs
}:
let
  rules = ''
      ACTION=="remove",\
       ENV{ID_BUS}=="usb",\
       ENV{ID_MODEL_ID}=="0407",\
       ENV{ID_VENDOR_ID}=="1050",\
       ENV{ID_VENDOR}=="Yubico",\
       RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
  '';
  content = pkgs.writeText "yubikey-screen-locking-udev.raw" rules;
in
stdenvNoCC.mkDerivation {
  name = "yubikey-screen-locking-udev-rules";

  dontUnpack = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm 644 "${content}" "$out/lib/udev/rules.d/99-yubikey-screen-locking-udev.rules"
  '';

  meta = with lib; {
    description = "udev rules to lock the screen when a yubikey is unplugged.";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
