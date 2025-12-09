{ pkgs, lib, config, ... }:

let
  cfg = config.jetbrains;
  ideaOptions = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
      };
      version = lib.mkOption {
        type = lib.types.str;
      };
      checksum = lib.mkOption {
        type = lib.types.str;
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
  intellijCfg = if cfg != null && cfg.intellij != null
    then
    {
      enable = cfg.intellij.enable;
      version = cfg.intellij.version;
      checksum = cfg.intellij.checksum;
      vmOptions = mergeVmOptionsOrDefault { set = cfg.intellij; defaults = cfg.defaultVmOptions; };
    }
    else
    {
      enable = false;
    };
  rustRoverCfg = if cfg != null && cfg.rustRover != null
    then
    {
      enable = cfg.rustRover.enable;
      version = cfg.rustRover.version;
      checksum = cfg.rustRover.checksum;
      vmOptions = mergeVmOptionsOrDefault { set = cfg.rustRover; defaults = cfg.defaultVmOptions; };
    }
    else
    {
      enable = false;
    };
  pycharmCfg = if cfg != null && cfg.pycharm != null
    then
    {
      enable = cfg.pycharm.enable;
      version = cfg.pycharm.version;
      checksum = cfg.pycharm.checksum;
      vmOptions = mergeVmOptionsOrDefault { set = cfg.pycharm; defaults = cfg.defaultVmOptions; };
    }
    else
    {
      enable = false;
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
    home.packages = with pkgs; []
      ++ lib.optional intellijCfg.enable ((jetbrains.idea-ultimate.overrideAttrs {
        version = intellijCfg.version;
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/idea/nextversion/
          url = "https://download-cdn.jetbrains.com/idea/idea-${intellijCfg.version}.tar.gz";
          sha256 = intellijCfg.checksum;
        };
      }).override {
        vmopts = renderVmOptions intellijCfg.vmOptions;
      })
      ++ lib.optional rustRoverCfg.enable ((jetbrains.rust-rover.overrideAttrs {
        version = rustRoverCfg.version;
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/rust/nextversion/
          url = "https://download-cdn.jetbrains.com/rustrover/RustRover-${rustRoverCfg.version}.tar.gz";
          sha256 = rustRoverCfg.checksum;
        };
      }).override {
        vmopts = renderVmOptions rustRoverCfg.vmOptions;
      })
      ++ lib.optional pycharmCfg.enable ((jetbrains.pycharm-professional.overrideAttrs {
        version = pycharmCfg.version;
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/pycharm/nextversion/
          url = "https://download-cdn.jetbrains.com/python/pycharm-${pycharmCfg.version}.tar.gz";
          sha256 = pycharmCfg.checksum;
        };
      }).override {
        vmopts = renderVmOptions pycharmCfg.vmOptions;
      });
  };
}
