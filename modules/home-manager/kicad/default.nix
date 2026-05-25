{ lib, config, pkgs, ... }:

let
  kicad = pkgs.kicad.override {
    addons = with pkgs.kicadAddons; [
      kikit
      kikit-library
    ];
  };
in
{
  options.kicad = {
    enable = lib.mkEnableOption "Enable KiCAD";
  };
  config = lib.mkIf config.kicad.enable {
    home.packages = [
      kicad
    ];
  };
}
