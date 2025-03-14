{ lib, config, ... }:

{
  options.eza = {
    enable = lib.mkEnableOption "Enable EZA";
  };
  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
    };
    programs.zsh = lib.mkIf config.zsh.enable {
      shellAliases = {
        ls = "eza";
        l = "eza -la";
        ll = "eza -l";
        la = "eza -la";
      };
    };
  };
}
