{ pkgs, lib, config, ... }:
let
  cfg = config.konsole;
in
{
  options.konsole = {
    enable = lib.mkEnableOption "Enable Konsole";
  };

  config = lib.mkIf cfg.enable {
    programs.konsole = {
      enable = true;
      defaultProfile = "Default";
      profiles =
      let
        profile = { color }: {
          colorScheme = color;
          command = "${pkgs.zsh}/bin/zsh";
          font = {
            name = "Hack";
            size = 10;
          };
          extraConfig = {
            Scrolling.HistorySize = 50000;
          };
        };
      in
      {
        "Default" = profile { color = "Breeze"; };
      };
    };
  };
}

