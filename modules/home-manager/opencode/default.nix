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

  defaultOptions = lib.types.submodule {
    options = {
      agent = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      model = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      small_model = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  permissionRuleOptions = lib.types.submodule {
    options = {
      action = lib.mkOption {
        type = lib.types.str;
      };
      resource = lib.mkOption {
        type = lib.types.str;
        default = "*";
      };
      effect = lib.mkOption {
        type = lib.types.enum [ "allow" "deny" "ask" ];
      };
    };
  };

  agentsOptions = lib.types.submodule {
    options = {
      description = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      mode = lib.mkOption {
        type = lib.types.nullOr (lib.types.enum [ "all" "primary" "subagent" ]);
        default = "primary";
      };
      prompt = lib.mkOption {
        type = lib.types.nullOr (lib.types.oneOf [ lib.types.str lib.types.path ]);
        default = null;
      };
      permissions = lib.mkOption {
        type = lib.types.listOf permissionRuleOptions;
        default = [];
      };
      temperature = lib.mkOption {
        type = lib.types.nullOr (lib.types.numbers.between 0.0 1.0);
        default = null;
      };
      tools = lib.mkOption {
        type = lib.types.nullOr lib.types.attrs;
        default = null;
      };
      color = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "#5c9cf5";
      };
    };
  };

  providerOptions = lib.types.submodule {
    options = {
      displayName = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      sdk = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      api = lib.mkOption {
        type = providerApiOptions;
      };
      settings = lib.mkOption {
        type = lib.types.attrs;
        default = {};
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
      capabilities = lib.mkOption {
        type = lib.types.nullOr providerModelCapabilitiesOptions;
        default = null;
      };
      cost = lib.mkOption {
        type = lib.types.nullOr providerModelCostOptions;
        default = null;
      };
      limit = lib.mkOption {
        type = lib.types.nullOr providerModelLimitsOptions;
        default = null;
      };
    };
  };

  providerModelCapabilitiesOptions = lib.types.submodule {
    options = {
      tools = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      input = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      output = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };
  };

  providerModelCostOptions = lib.types.submodule {
    options = {
      input = lib.mkOption {
        type = lib.types.numbers.nonnegative;
      };
      output = lib.mkOption {
        type = lib.types.numbers.nonnegative;
      };
      cache = lib.mkOption {
        type = lib.types.nullOr providerModelCostCacheOptions;
        default = null;
      };
    };
  };

  providerModelCostCacheOptions = lib.types.submodule {
    options = {
      read = lib.mkOption {
        type = lib.types.numbers.nonnegative;
      };
      write = lib.mkOption {
        type = lib.types.numbers.nonnegative;
      };
    };
  };

  providerModelLimitsOptions = lib.types.submodule {
    options = {
      context = lib.mkOption {
        type = lib.types.numbers.nonnegative;
        default = 0.0;
      };
      output = lib.mkOption {
        type = lib.types.numbers.nonnegative;
        default = 0.0;
      };
    };
  };

  mcpOptions = lib.types.submodule {
    options = {
      github = lib.mkOption {
        type = mcpGitHubOptions;
      };
    };
  };

  mcpGitHubOptions = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      pat = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  # nixpkgs#582673: wrong node_modules hash for opencode 2.2.5 (bun 1.4.4)
  opencode = pkgs.opencode.overrideAttrs (old: lib.optionalAttrs (old.version == "2.2.5") {
    node_modules = old.node_modules.overrideAttrs {
      outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
    };
  });

  settings = import ./settings.nix { inherit lib pkgs; } {
    agents = cfg.agents;
    defaults = cfg.defaults;
    providers = cfg.providers;
    mcp = cfg.mcp;
  };
in
{
  options.opencode = {
    enable = lib.mkEnableOption "Enable OpenCode";

    defaults = lib.mkOption {
      type = defaultOptions;
    };

    agents = lib.mkOption {
      type = lib.types.attrsOf agentsOptions;
      default = {};
      description = "List of agents.";
    };

    providers = lib.mkOption {
      type = lib.types.attrsOf providerOptions;
      default = {};
      description = "List of providers.";
    };

    mcp = lib.mkOption {
      type = mcpOptions;
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
      opencode
    ];
    home.file = skillFiles // commandFiles // {
      "${configDir}/opencode.json".text = settings.json;
    };
  };
}
