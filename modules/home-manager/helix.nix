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
        editor = {
          color-modes = true;
          bufferline = "multiple";
          statusline = {
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          whitespace.render = {
            space = "all";
            tab = "all";
            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
          lsp = {
            display-messages = true;
          };
          inline-diagnostics = {
            cursor-line = "hint";
            other-lines = "disable";
          };
        };
        keys.normal = {
          C-right = "move_next_word_start";
          C-left = "move_prev_word_end";
          C-S-right = "extend_next_word_end";
          C-S-left = "extend_prev_word_start";
          tab = "indent";
          S-tab = "unindent";
        };
        keys.insert = {
          C-right = "move_next_word_start";
          C-left = "move_prev_word_end";
          C-S-right = "extend_next_word_end";
          C-S-left = "extend_prev_word_start";
        };
        keys.select = {
          tab = "indent";
          S-tab = "unindent";
        };
      };
      languages = {
         language = [
           {
             name = "json";
             auto-format = true;
             formatter = {
               command = "${pkgs.prettier}/bin/prettier";
               args = [ "--parser" "json" ];
             };
             language-servers = [ "vscode-json-languageserver" ];
           }
           {
             name = "jsonc";
             auto-format = true;
             formatter = {
               command = "${pkgs.prettier}/bin/prettier";
               args = [ "--parser" "json" ];
             };
             language-servers = [ "vscode-json-languageserver" ];
           }
          {
            name = "rust";
            auto-format = true;
            formatter.command = "${pkgs.rustfmt}/bin/rustfmt";
          }
        ];
       language-server = {
         vscode-json-languageserver = {
           command = "${pkgs.vscode-json-languageserver}/bin/vscode-json-languageserver";
           args = [ "--stdio" ];
           config = {};
         };
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            config = {
              check = { command = "${pkgs.clippy}/bin/cargo-clippy"; };
              cargo = { features = "all"; };
            };
          };
        };
      };
    };
  };
}
