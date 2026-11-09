{ lib, config, pkgs, ... }:

let
  cfg = config.vibe;
in
{
  options.vibe = {
    enable = lib.mkEnableOption "Mistral Vibe CLI";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.mistral-vibe
    ];
  };
}
