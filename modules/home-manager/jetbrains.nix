{ pkgs, pkgs-stable, lib, config, ... }:

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
    home.packages = with pkgs; []
      ++ lib.optional intellijCfg.enable ((jetbrains.idea-ultimate.overrideAttrs {
        version = "2025.3";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/idea/nextversion/
          url = "https://download-cdn.jetbrains.com/idea/idea-253.28294.169.tar.gz";
          sha256 = "713ebeb0b2ada110ed19a79cb2fb03bc790a0ec02fe6c4ba1fcfce4d4f0a4d18";
        };
      }).override {
        vmopts = renderVmOptions intellijCfg.vmOptions;
      })
      ++ lib.optional rustRoverCfg.enable ((jetbrains.rust-rover.overrideAttrs {
        version = "2025.3";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/rust/nextversion/
          url = "https://download-cdn.jetbrains.com/rustrover/RustRover-253.28294.127.tar.gz";
          sha256 = "b758a84eb88761361012bd381a0d05b926cdb0183210165963b3856981de9d33";
        };
      }).override {
        vmopts = renderVmOptions rustRoverCfg.vmOptions;
      })
      ++ lib.optional pycharmCfg.enable ((jetbrains.pycharm-professional.overrideAttrs {
        version = "2025.2.0.1";
        src = pkgs.fetchurl {
          # https://www.jetbrains.com/de-de/pycharm/nextversion/
          url = "https://download-cdn.jetbrains.com/python/pycharm-2025.2.2.tar.gz";
          sha256 = "6ffd11bc2ab84f57e90683ce5a9c73ff6ec47e5746e7e4d7ce5f2dc335af6481";
        };
      }).override {
        vmopts = renderVmOptions pycharmCfg.vmOptions;
      });
  };
}
