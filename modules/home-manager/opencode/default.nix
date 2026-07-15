{ lib, config, pkgs, ... }:

{
  options.opencode = {
    enable = lib.mkEnableOption "Enable OpenCode";
  };
  config = lib.mkIf config.opencode.enable {
    home.packages = [
      pkgs.opencode
    ];
  };
}
