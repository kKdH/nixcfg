{ lib, config, pkgs, ... }:

let
  cfg = config.herdr;
in
{
  options.herdr = {
    enable = lib.mkEnableOption "Enable herdr";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      herdr
      herdr-desktop
    ];
  };
}
