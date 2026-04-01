{
  lib,
  stdenvNoCC,
  udevCheckHook,
  pkgs
}:
let
  rules = ''
      KERNEL=="uinput",\
      MODE="0660",\
      GROUP="wheel",\
      OPTIONS+="static_node=uinput"
  '';
  content = pkgs.writeText "weylus-uinput-udev.raw" rules;
in
stdenvNoCC.mkDerivation {
  name = "weylus-uinput-udev-rules";

  dontUnpack = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm 644 "${content}" "$out/lib/udev/rules.d/99-weylus-uinput-udev.rules"
  '';

  meta = with lib; {
    description = "udev rules to enable uinput for a given group of users.";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
