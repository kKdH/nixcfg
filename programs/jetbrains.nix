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
        version = "2025.1.0";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/idea/nextversion/
          url = "https://download-cdn.jetbrains.com/idea/ideaIU-2025.1.1.tar.gz";
          sha256 = "17d959a3adc60ed25ff7740b0acfcbbbe40b58cba13dcd97a6a6217ef7227a75";
        };
      }).override {
        vmopts = renderVmOptions intellijCfg.vmOptions;
      })
      ++ lib.optional rustRoverCfg.enable ((pkgs.jetbrains.rust-rover.overrideAttrs {
        version = "2025.1.2";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/rust/nextversion/
          url = "https://download-cdn.jetbrains.com/rustrover/RustRover-2025.1.2.tar.gz";
          sha256 = "b2974feb5406153817797b7dc93baaafe35c7b3687d38091d5d1b5d010a03132";
        };
      }).override {
        vmopts = renderVmOptions rustRoverCfg.vmOptions;
      })
      ++ lib.optional pycharmCfg.enable ((pkgs.jetbrains.pycharm-professional.overrideAttrs {
        version = "2025.1.0";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/pycharm/nextversion/
          url = "https://download-cdn.jetbrains.com/python/pycharm-2025.1.tar.gz";
          sha256 = "1282907f134a726e17bb7fe8cb7088e406aa4fbf9d910def03633572f3a62f8c";
        };
      }).override {
        vmopts = renderVmOptions pycharmCfg.vmOptions;
      });
  };
}
