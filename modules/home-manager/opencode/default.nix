{ lib, config, pkgs, ... }:

let
  cfg = config.opencode;
  configDir = "${config.xdg.configHome}/opencode";
  commandsConfigDir = "${configDir}/commands";
  skillsConfigDir = "${configDir}/skills";

  availableSkills = [ "caveman" ];
  availableCommands = [ "caveman" ];

  selectedSkills = lib.intersectLists cfg.skills availableSkills;
  selectedCommands = lib.intersectLists cfg.commands availableCommands;

  skillFiles = lib.listToAttrs (map (skillName: {
    name = "${skillsConfigDir}/${skillName}";
    value = {
      source = ./skills/${skillName};
      recursive = true;
      force = true;
    };
  }) selectedSkills);

  commandFiles = lib.listToAttrs (map (commandName: {
    name = "${commandsConfigDir}/${commandName}.md";
    value = {
      source = ./commands/${commandName}.md;
      force = true;
    };
  }) selectedCommands);

  providerOptions = lib.types.submodule {
    options = {
      displayName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      sdk = lib.mkOption {
        type = lib.types.str;
      };
      api = lib.mkOption {
        type = providerApiOptions;
      };
      models = lib.mkOption {
        type = lib.types.attrsOf providerModelOptions;
      };
    };
  };

  providerApiOptions = lib.types.submodule {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
      };
      key = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  providerModelOptions = lib.types.submodule {
    options = {
      displayName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      cost = lib.mkOption {
        type = lib.types.nullOr providerModelCostOptions;
        default = null;
      };
    };
  };

  providerModelCostOptions = lib.types.submodule {
    options = {
      input = lib.mkOption {
        type = lib.types.float;
      };
      output = lib.mkOption {
        type = lib.types.float;
      };
    };
  };

  settings = import ./settings.nix { inherit lib; } {
    providers = cfg.providers;
  };
in
{
  options.opencode = {
    enable = lib.mkEnableOption "Enable OpenCode";

    providers = lib.mkOption {
      type = lib.types.attrsOf providerOptions;
      default = {};
      description = "List of providers";
    };

    skills = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of skills to install. Available: ${lib.concatStringsSep ", " availableSkills}";
    };

    commands = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of commands to install. Available: ${lib.concatStringsSep ", " availableCommands}";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
    ];
    home.file = skillFiles // commandFiles // {
      "${configDir}/opencode.json".text = settings.json;
    };
  };
}
