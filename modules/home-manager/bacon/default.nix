{ lib, config, ... }:

{
  options = {
    bacon.enable = lib.mkEnableOption "Enable Bacon";
  };

  config = lib.mkIf config.git.enable {
    programs.bacon = {
      enable = true;
    };
    home.file."${config.xdg.configHome}/bacon/prefs.toml" = {
      source = ./prefs.toml;
    };
  };
}
