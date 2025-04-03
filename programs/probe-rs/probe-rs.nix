{ pkgs, lib, config, ... }:

{
  options = {
    probe-rs.enable = lib.mkEnableOption "Enable probe-rs";
  };

  config = lib.mkIf config.probe-rs.enable {
    home.packages = [
      pkgs.probe-rs-tools
    ];
    # services.udev.extraRules = builtins.readFile ./probe-rs.udev.rules;
  };
}
