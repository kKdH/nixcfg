{ lib, config, pkgs-stable, ... }:

{
  options.freecad = {
    enable = lib.mkEnableOption "Enable FreeCAD";
  };
  config = lib.mkIf config.freecad.enable {
    home.packages = [
      pkgs-stable.freecad
    ];
  };
}
