{ pkgs, lib, config, ... }:

{
  options.zsh = {
    enable = lib.mkEnableOption "Enable ZSH";
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of plugins to activate.";
    };
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "List of command aliases to add.";
    };
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=245";
      };
      syntaxHighlighting.enable = true;
      history.size = 10000;
      shellAliases = config.zsh.aliases;
      oh-my-zsh = {
        enable = true;
        plugins = config.zsh.plugins;
        theme = "agnoster";
      };
    };
  };
}
