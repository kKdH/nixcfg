{ lib, config, ... }:

{
  options = {
    sshconfig.enable = lib.mkEnableOption "Enable SSH config";
  };

  config = lib.mkIf config.sshconfig.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname =  "github.com";
          identityFile = "~/.ssh/elmar.schug@jayware.org.id_rsa";
          user = "git";
        };
        "git.daimler.com" = {
          hostname = "git.daimler.com";
          identityFile = "~/.ssh/elschug.id.rsa";
          user = "git";
        };
        "git.i.mercedes-benz.com" = {
          hostname = "git.i.mercedes-benz.com";
          identityFile = "~/.ssh/elmar.schug@mercedes-benz.com.id.rsa";
          user = "git";
        };
        "raspberrypi homepi" = {
          hostname = "raspberrypi";
          identityFile = "~/.ssh/elmar.schug@home_pi.id_rsa";
          identitiesOnly = true;
          user = "elmar";
        };
        "fuji 192.168.0.10" = {
          hostname = "192.168.0.10";
          identityFile = "~/.ssh/elmar.schug@smarthome.id_rsa";
          identitiesOnly = true;
          user = "root";
        };
      };
    };
  };
}
