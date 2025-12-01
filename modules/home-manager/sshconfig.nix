{ lib, config, ... }:

{
  options = {
    sshconfig.enable = lib.mkEnableOption "Enable SSH config";
  };

  config = lib.mkIf config.sshconfig.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      includes = [
        "local.conf"
      ];
      matchBlocks = {
        "github.com" = {
          hostname =  "github.com";
          identityFile = "~/.ssh/github.com.id_ed25519";
          user = "git";
        };
        "raspberrypi homepi" = {
          hostname = "raspberrypi";
          identityFile = "~/.ssh/elmar.schug@home_pi.id_rsa";
          identitiesOnly = true;
          user = "elmar";
        };
        "fuji 192.168.122.173" = {
          hostname = "192.168.122.173";
          identityFile = "~/.ssh/elmar.schug@jayware.org.id_rsa";
          identitiesOnly = true;
          user = "elmar";
        };
      };
    };
  };
}
