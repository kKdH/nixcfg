{ lib, config, ... }:

let
  destinationConfigPath = "${config.xdg.configHome}/zellij/config.kdl";
in
{
  options.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };
  config = lib.mkIf config.zellij.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
    home.file = {
      ${destinationConfigPath} = {
        source = ./config.kdl;
      };
    };
  };
}
