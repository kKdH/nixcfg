{ pkgs, lib, config, ... }:

{
  options = {
    git.enable = lib.mkEnableOption "Enable Git";
    git.userName = lib.mkOption {
      type = lib.types.str;
    };
    git.userEmail = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      userName = config.git.userName;
      userEmail = config.git.userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = "*";
      };
    };
  };
}
