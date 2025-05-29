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
  pycharmCfg = {
    enable = cfg.pycharm.enable;
    vmOptions = mergeVmOptionsOrDefault { set = cfg.pycharm; defaults = cfg.defaultVmOptions; };
  };
  enabled = intellijCfg.enable || rustRoverCfg.enable || pycharmCfg.enable;
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
    jetbrains.pycharm = lib.mkOption {
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
        version = "2025.3.0";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/idea/nextversion/
          url = "https://download-cdn.jetbrains.com/idea/ideaIU-252.16512.17.tar.gz";
          sha256 = "460619a1e40382157d67cb802566de6469483da1dbbf2c0d35b7fc471d57a210";
        };
      }).override {
        vmopts = renderVmOptions intellijCfg.vmOptions;
      })
      ++ lib.optional rustRoverCfg.enable ((pkgs.jetbrains.rust-rover.overrideAttrs {
        version = "2025.2";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/rust/nextversion/
          url = "https://download-cdn.jetbrains.com/rustrover/RustRover-252.16512.28.tar.gz";
          sha256 = "cdee166c8ea705a36d6811c137e7539dab8bb04a587ff40961a9cc1b7089039f";
        };
      }).override {
        vmopts = renderVmOptions rustRoverCfg.vmOptions;
      })
      ++ lib.optional pycharmCfg.enable ((pkgs.jetbrains.pycharm-professional.overrideAttrs {
        version = "2025.2";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/pycharm/nextversion/
          url = "https://download-cdn.jetbrains.com/python/pycharm-252.16512.37.tar.gz";
          sha256 = "69d097510a0499040c5ed95c1432512b5fc4def71789ac2d9347b7a1bcc26dd2";
        };
      }).override {
        vmopts = renderVmOptions pycharmCfg.vmOptions;
      });
  };
}
