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
        version = "2025.1.1";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/idea/nextversion/
          url = "https://download-cdn.jetbrains.com/idea/ideaIU-2025.1.1.1.tar.gz";
          sha256 = "337d34b20cdaa8da30d71b98e1b36817bdfe2f2245c491ef38f0cee02f0d0316";
        };
      }).override {
        vmopts = renderVmOptions intellijCfg.vmOptions;
      })
      ++ lib.optional rustRoverCfg.enable ((pkgs.jetbrains.rust-rover.overrideAttrs {
        version = "2025.1.3";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/rust/nextversion/
          url = "https://download-cdn.jetbrains.com/rustrover/RustRover-2025.1.4.tar.gz";
          sha256 = "88c6bfabe324af665692562ae32c61b9eb1cf3e0afe05b3aa2a835a5a14c181a";
        };
      }).override {
        vmopts = renderVmOptions rustRoverCfg.vmOptions;
      })
      ++ lib.optional pycharmCfg.enable ((pkgs.jetbrains.pycharm-professional.overrideAttrs {
        version = "2025.1.1";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/pycharm/nextversion/
          url = "https://download-cdn.jetbrains.com/python/pycharm-2025.1.1.1.tar.gz";
          sha256 = "f5df74fcb44c3a152005c844dfa3e66efe2999a41c120f1c575466180e1ee6ba";
        };
      }).override {
        vmopts = renderVmOptions pycharmCfg.vmOptions;
      });
  };
}
