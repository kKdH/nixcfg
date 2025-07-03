{ lib, config, ... }:

let
  cfg = config.my.probe-rs-udev-rules;
in
{
  options.my.probe-rs-udev-rules = {
    enable = lib.mkEnableOption "Enables custom udev rules for probe-rs";
  };

  config = lib.mkIf cfg.enable {
     services.udev.extraRules = builtins.readFile ./probe-rs.udev.rules;
  };
}
