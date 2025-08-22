{ lib, config, ... }:

{
  options.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty";
  };
  config = lib.mkIf config.zsh.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
