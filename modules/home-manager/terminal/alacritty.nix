{ lib, config, ... }:

{
  options.alacritty = {
    enable = lib.mkEnableOption "Enable alacritty";
  };
  config = lib.mkIf config.alacritty.enable {
    programs.alacritty = {
      enable = true;
    };
  };
}
