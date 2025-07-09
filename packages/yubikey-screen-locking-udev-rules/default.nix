{
  lib,
  stdenvNoCC,
  udevCheckHook,
  pkgs
}:
let
  rules = ''
      ACTION=="remove",\
       ENV{SUBSYSTEM}=="usb",\
       ENV{PRODUCT}=="1050/407/*",\
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
