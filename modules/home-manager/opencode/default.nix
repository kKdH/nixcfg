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
in
{
  options.opencode = {
    enable = lib.mkEnableOption "Enable OpenCode";

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

    home.file = skillFiles // commandFiles;
  };
}
