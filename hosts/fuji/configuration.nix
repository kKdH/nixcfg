# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd = {
    enable = true;
    supportedFilesystems = [ "btrfs" ];

    postResumeCommands = lib.mkAfter ''
      mkdir -p /mnt
      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/vda3 /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
      cut -f9 -d' ' |
      while read subvolume; do
        echo "deleting /$subvolume subvolume..."
        btrfs subvolume delete "/mnt/$subvolume"
      done &&
      echo "deleting /root subvolume..." &&
      btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };


  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking = {
    hostName = "fuji";
    useDHCP = false;
    interfaces = {
      eth0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = "192.168.0.10";
          prefixLength = 24;
        }];
      };
    };
  };

  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "52:54:00:cc:53:49";
    linkConfig.Name = "eth0";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.elmar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQDbtYQ6Ot/BswNMiz1+nN9/feSzSnv9N+mjHQ2wVyY57YEpenhFhjsHNPCkuMgwIhB5a7CDWZMm6gurKbqBSH4Ytepe/7KVmdYND9YBb0PpDZi3StcXkvW+O+GAAuAUBVKJx50EpbRai1fF85kmMFVjZDzOxIWO/x1IiVGLG68XCaDmKQjpgIjmqZWpMeKqpvUwX2hKDcpOs66Hhb7ipDn7omHbXnjtG12Daft2MVygPyMD3lTwcTJC+PQ43ql+2ghKu0bCsXmGz8T38WaPBC/Z2hmzeAe/fnRwODeUMuwhLbSk/jiZm7imNyVke5AgDhoPlRRrmvnCmxlMLjADAp11xEL5P1ORZvjQhW5dMKk3OmbbuI84HAA09n4i1bC89AJdLUMOWZt3m7sYTAoluVoUr2iMIwmKsiH2kaPwqSmwB4HI10g3BhpTx7S4ZYcNmrZclnu1ZBm4VHVhNuBjhaBsk8RimG9XQgVknkw5CT6mpaA7OvGQWRx5mVOmBfOLUtg4DwRLVgKYJTKMFw5IPfTS59j3oCb7N5rbIH8SFX9pIHRYDUzo47E8LIivaNmUuRhyYG4CDYWCTcU3q4uVM8QGKeMKhkJxsW3vSxGD4Dv0vrd/5hrcY/eGTSCUHg8ytYSIjTq6eDN67cwJxyFbbTv1IDvLuwQKMztO+7Kc7/m4ZdyD0s0s/CCyI7gBd0lFTNnCYHWv5TdbUQNe+s07lrc24H+b0TMLGVmdu92LsIDEjrH09g1/jgkUSnO+QzBjq997I2SOelmY2aapMXSaqwKqHBTJDryx4IWYpIm/6GcVj01f3BYqkSMMULeteS/y+08s/BVTzcixr/asi1kgWKt8ZXCez3rDALbPMEg8JLSiLMgSXq8oqSHEVT3p4kxBGcfwJWSslfi4rxXcdVqG7sRoBD5EL5UZXi3unhbph7snresLYzWnnQ6sCDSDRhOqX9/vkBK64sASAXtjyMlLbiji8QejSVfiHjQFs6h1Y9tNsgveM9lyl7P75TUAzeGVt0f0sQIcSxX0m7RR/YI9rWhiPG0QOW7o4EifwSI8cqF2vCd3Sz7iJ9g+jGr3ubcaBRXH3CQ/EEeU9jU4kdQCZ3DkvbaGB6hV9c3ex9hA9wBKuf6+yOQ7xTNhUqkDMEeOZ0T7/6varn9enrB6RY5mN2A0ewRr1XH2onUFEYpdv+xRE+kcGiKKCUDsCCUMejEYdzJBU5/LOKK7cPYpnCCfkLa77QEfc2zV240no4gPPMUGJ+zj7fwwMs0AbwomAm84kBmTSSfJGA/IObQl65/MHLYDedKr0fnZYCpSw7+V6mjZNbNULrrojU0N3wf8Rup4zNcwzY+CTBhrKX+Q5LiaCH4Z elmar.schug@jayware.com"
    ];
    hashedPasswordFile = "/persist/passwords/elmar";
    packages = with pkgs; [
    ];
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [
    "elmar"
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    curl
    dhcping
    tree
    vim
    zsh
  ];

  environment.persistence."/persist" = {
    directories = [
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  security.sudo.extraConfig = ''
    # rollback results in sudo lectures after each reboot
    Defaults lecture = never
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  dnsmasq = {
    enable = true;
    interface = "eth0";
  };

  rusty-nix = {
    enable = true;
    data-directory = "/persistent/rusty-nix";
    user.name = "test";
    service.name = "rusty";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
    allowSFTP = false; # Don't set this if you need sftp
    extraConfig = ''
      AllowTcpForwarding yes
      X11Forwarding no
      AllowAgentForwarding no
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # ssh
      67 # dhcp
      53 # dns
    ];
    allowedUDPPorts = [ ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

