{ lib, config, pkgs, ... }:

let
  slicerConfigDir = "${config.xdg.configHome}/PrusaSlicer";
  filamentConfigDir = "${slicerConfigDir}/filament";
  printConfigDir = "${slicerConfigDir}/print";
  printerConfigDir = "${slicerConfigDir}/printer";
in
{
  options.prusa-slicer = {
    enable = lib.mkEnableOption "Enable Prusa Slicer";
  };
  config = lib.mkIf config.prusa-slicer.enable {
    home.packages = [
      pkgs.prusa-slicer
    ];
    home.file = {
      ${filamentConfigDir} = {
        source = ./filament;
        recursive = true;
      };
      ${printConfigDir} = {
        source = ./print;
        recursive = true;
      };
      ${printerConfigDir} = {
        source = ./printer;
        recursive = true;
      };
    };
  };
}
