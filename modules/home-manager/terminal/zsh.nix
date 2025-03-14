{ pkgs, lib, config, ... }:

{
  options.zsh = {
    enable = lib.mkEnableOption "Enable ZSH";
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of plugins to activate.";
    };
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      history.size = 10000;
      shellAliases = { };
      oh-my-zsh = {
        enable = true;
        plugins = config.zsh.plugins;
        theme = "agnoster";
      };
    };
  };
}
