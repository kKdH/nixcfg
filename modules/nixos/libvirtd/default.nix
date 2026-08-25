{ pkgs, lib, config, ... }:
{
  options = {
    libvirtd.enable = lib.mkEnableOption "Enable libvirtd";
    libvirtd.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users to add to the libvirtd group";
    };
  };

  config = lib.mkIf config.libvirtd.enable {
    virtualisation.libvirtd.enable = true;

    users.users = lib.genAttrs config.libvirtd.users (_: {
      extraGroups = [ "libvirtd" ];
    });
  };
}
