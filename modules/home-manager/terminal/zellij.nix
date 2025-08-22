{ lib, config, ... }:

{
  options.zellij = {
    enable = lib.mkEnableOption "Enable zellij";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
