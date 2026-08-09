{ lib, config, pkgs, ... }:

{
  options.freecad = {
    enable = lib.mkEnableOption "Enable FreeCAD";
  };
  config = lib.mkIf config.freecad.enable {
    home.packages = [
      pkgs.freecad
    ];
  };
}
