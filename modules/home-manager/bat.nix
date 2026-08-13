{ lib, config, ... }:

{
  options.bat = {
    enable = lib.mkEnableOption "Enable Bat";
  };
  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
    };
    programs.zsh = lib.mkIf config.zsh.enable {
      shellAliases = {
        less = "bat";
        cat = "bat";
      };
    };
  };
}
