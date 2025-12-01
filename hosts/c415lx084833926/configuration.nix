# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, picoscope-pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      picoscope = picoscope-pkgs.picoscope;
    })
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };

  # luks
  boot = {
    # kernelParams = [ "nvidia-drm.fbdev=1" ];
    initrd = {
      # kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      luks.devices = {
        crypted = {
          device = "/dev/nvme0n1p3";
          preLVM = true;
        };
      };
    };
  };

  environment.etc."u2f_keys" = {
    text = ''
      elmar:BSyXyknlRYwPgP09BYo5lesdfC0QTSAMQOdKOTE5hNgB6cw4zuPmiEaSBVroQ31pAYKH8sTix5s97iDwmXm5bg==,ni7Y85HxmhVMNfVcwe7A7WHM9KcyGEBn+Xq67dxrBRuIjdnoOmbMsz5wM3z7UxeD422I/hvYW2FMUAfmHMXhbg==,es256,+presence%
    '';
  };

  security.pam = {
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
    u2f = {
      enable = true;
      settings = {
        interactive = false; # will prompt you with Insert your U2F device, then press ENTER.
        cue = true; # will print Please touch the device. when your action is required.
        authfile = "${config.environment.etc.u2f_keys.source}";
      };
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  # };
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.latest;

    prime = {
      offload = {
        enable = false;
        enableOffloadCmd = false;
      };
      intelBusId = "PCI:0:2:0"; # 00:02.0
      nvidiaBusId = "PCI:1:0:0"; # 01:00.0
    };
  };

  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true; # powers up the default Bluetooth controller on boot
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  # Enable the GNOME Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = false;
  services.avahi = {
    enable = false;
    nssmdns4 = false;
    openFirewall = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  security.rtkit.enable = true; # rtkit is optional but recommended for pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  services.udev.packages = [
    (pkgs.callPackage ../../packages/probe-rs-udev-rules {})
    (pkgs.callPackage ../../packages/yubikey-screen-locking-udev-rules {})
    pkgs.yubikey-personalization
  ];

  # Smart card mode for Yubikey
  hardware.gpgSmartcards.enable = true;
  services.pcscd.enable = true;

  virtualisation = {
    docker = {
      enable = true; # system-wide
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        # data-root = "/some-place/to-store-the-docker-data";
      };
      storageDriver = "btrfs";
    };
    libvirtd = {
      enable = true;
    };
  };

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.elmar = {
    isNormalUser = true;
    home = "/home/elmar";
    extraGroups = [ "wheel" "dialout" "libvirtd" "docker" ];
  };

  # sops = {
  #   defaultSopsFile = ./secrets/secrets.yaml;
  #   age.keyFile = "${config.users.users.elmar.home}/.config/sops/age/keys.txt";
  # };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    curl
    git
    keepassxc
    pcsclite
    sops
    age
    tree
    vim
    wget
    zsh
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  networking = {
    hostName = "c415lx084833926";
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    firewall = {
      enable = true;
      trustedInterfaces = [ "virbr0" ];
      allowedTCPPorts = [
      # 5001 # gRPC e.g. ANNE
      ];
    };
  };

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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


