{ lib, config, ... }:

{
  options.bat = {
    enable = lib.mkEnableOption "Enable Bat";
  };
  config = lib.mkIf config.eza.enable {
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
