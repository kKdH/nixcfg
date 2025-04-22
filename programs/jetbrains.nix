{ pkgs, lib, config, ... }:

let
  cfg = config.jetbrains;
  ideaOptions = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
      };
      vmOptions = lib.mkOption {
        type = lib.types.nullOr vmOptions;
        default = null;
      };
    };
  };
  vmOptions = with lib.types; submodule {
    options = {
      minMemory = lib.mkOption {
        type = nullOr ints.positive;
        default = null;
      };
      maxMemory = lib.mkOption {
        type = nullOr ints.positive;
        default = null;
      };
      awtToolkit = lib.mkOption {
        type = nullOr (enum [ "wayland" ]);
        default = null;
      };
    };
  };
  mergeVmOptionsOrDefault = { set, defaults }: if set != null && set.vmOptions != null
      then
        defaults // lib.filterAttrs (f: attr: attr != null) set.vmOptions
      else
        defaults;
  renderToolkitOption = toolkit:
    if toolkit == "wayland" then
      "-Dawt.toolkit.name=WLToolkit"
    else
      abort "unkown enum variant";
  renderVmOptions = options:
    lib.concatStrings [
      (lib.optionalString (options.minMemory != null)
        "-Xms${toString(options.minMemory)}m\n"
      )
      (lib.optionalString (options.maxMemory != null)
        "-Xmx${toString(options.maxMemory)}m\n"
      )
      (lib.optionalString (options.awtToolkit != null)
        "${renderToolkitOption options.awtToolkit}\n"
      )
    ];
  intellijCfg = {
    enable = cfg.intellij.enable;
    vmOptions = mergeVmOptionsOrDefault { set = cfg.intellij; defaults = cfg.defaultVmOptions; };
  };
  rustRoverCfg = {
    enable = cfg.rustRover.enable;
    vmOptions = mergeVmOptionsOrDefault { set = cfg.rustRover; defaults = cfg.defaultVmOptions; };
  };
  enabled = intellijCfg.enable || rustRoverCfg.enable;
in
{
  options = {
    jetbrains.intellij = lib.mkOption {
      type = lib.types.nullOr ideaOptions;
      default = null;
    };
    jetbrains.rustRover = lib.mkOption {
      type = lib.types.nullOr ideaOptions;
      default = null;
    };
    jetbrains.defaultVmOptions = lib.mkOption {
      type = lib.types.nullOr vmOptions;
      default = null;
    };
  };
  config = lib.mkIf enabled {
    home.packages = []
      ++ lib.optional intellijCfg.enable ((pkgs.jetbrains.idea-ultimate.overrideAttrs {
        version = "2025.1.0";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/idea/nextversion/
          url = "https://download-cdn.jetbrains.com/idea/ideaIU-2025.1.tar.gz";
          sha256 = "7ce57055e3a5ee92582eb90c2dea469b48a6e7165e74fe085ef1923c16ba7faa";
        };
      }).override {
        vmopts = renderVmOptions intellijCfg.vmOptions;
      })
      ++ lib.optional rustRoverCfg.enable ((pkgs.jetbrains.rust-rover.overrideAttrs {
        version = "2025.1.0";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/rust/nextversion/
          url = "https://download-cdn.jetbrains.com/rustrover/RustRover-2025.1.tar.gz";
          sha256 = "6c3e5c2cc45bfbfe631f6f34f87d45fbc3e3f97d12a8ca9e6de77beab230a210";
        };
      }).override {
        vmopts = renderVmOptions rustRoverCfg.vmOptions;
      });
  };
}
