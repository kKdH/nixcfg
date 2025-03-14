{
  lib,
  stdenvNoCC,
  udevCheckHook,
}:

stdenvNoCC.mkDerivation {
  name = "probe-rs-udev-rules";
 
  dontUnpack = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installPhase = ''
    install -Dm 644 "${./probe-rs.udev.rules}" "$out/lib/udev/rules.d/99-probe-rs.rules"
  '';

  meta = with lib; {
    description = "udev rules that give NixOS permission to communicate with probes";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
