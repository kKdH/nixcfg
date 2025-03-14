{ pkgs, lib, config, ... }:

{

  options = {
    helix.enable = lib.mkEnableOption "Enables Helix editor"; 
  };

  config = lib.mkIf config.helix.enable {

    home.packages = with pkgs; [
      nil # nix
    ];

    programs.helix = {
      enable = true;
      defaultEditor = true; # TODO: does it really work?
      settings = {
        theme = "dark_plus";
        editor.whitespace.render = {
          space = "all";
          tab = "all";
          nbsp = "none";
          nnbsp = "none";
          newline = "none";
        };
        keys.normal = {
          C-right = "move_next_word_start";
          C-left = "move_prev_word_end";
          C-S-right = "extend_next_word_end";
          C-S-left = "extend_prev_word_start";
        };
        keys.insert = {
          C-right = "move_next_word_start";
          C-left = "move_prev_word_end";
          C-S-right = "extend_next_word_end";
          C-S-left = "extend_prev_word_start";
        };
      };
    };
  };
}
