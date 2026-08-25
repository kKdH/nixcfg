{ pkgs, lib, config, ... }:
let
  cfg = config.docker;
in
{
  options = {
    docker.enable = lib.mkEnableOption "Enable Docker";
    docker.users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Users to add to the docker group";
    };
    docker.quotaSize = lib.mkOption {
      type = lib.types.str;
      default = "50G";
      example = "100G";
      description = ''
        Quota for the Docker btrfs subvolume (e.g. "50G").
        Enforced via `btrfs qgroup limit` on the Docker subvolume.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Create subvolume + enable quota on boot
    systemd.services.docker-subvolume = {
      requiredBy = [ "docker.service" ];
      before = [ "docker.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.btrfs-progs}/bin/btrfs subvolume create /var/lib/docker 2>/dev/null || true
        ${pkgs.btrfs-progs}/bin/btrfs quota enable /var/lib/docker 2>/dev/null || true
        ${pkgs.btrfs-progs}/bin/btrfs qgroup limit ${cfg.quotaSize} /var/lib/docker
      '';
    };

    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = false;
        setSocketVariable = true;
      };
      storageDriver = "btrfs";
    };

    users.users = lib.genAttrs cfg.users (_: {
      extraGroups = [ "docker" ];
    });
  };
}
