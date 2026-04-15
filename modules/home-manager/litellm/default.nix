{ pkgs, lib, config, ... }:
let
  litellmServiceOptions = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 4000;
      };
      configFile = lib.mkOption {
        type = lib.types.path;
        default = "${config.xdg.configHome}/litellm/config.yaml";
      };
    };
  };
in
{
  options = {
    litellm.enable = lib.mkEnableOption "Enable LiteLLM";
    litellm.service = lib.mkOption {
      type = lib.types.nullOr litellmServiceOptions;
      default = null;
    };
  };
  config = lib.mkIf config.litellm.enable {
    home.packages = [
      pkgs.litellm
    ];
    systemd.user.services.litellm = lib.mkIf (config.litellm.service != null && config.litellm.service.enable) {
      Unit = {
        Description = "User service to run LiteLLM in the background.";
        X-SwitchMethod = "stop-start";
        X-Restart-Triggers = [];
      };
      Service = {
        Environment = [];
        ExecStart = lib.strings.concatStringsSep " " [
          "${lib.getExe pkgs.litellm}"
            "--host ${config.litellm.service.host}"
            "--port ${toString config.litellm.service.port}"
            "--config ${config.litellm.service.configFile}"
        ];
      };
    };
  };
}
