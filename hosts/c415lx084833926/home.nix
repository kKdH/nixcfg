{ pkgs, ... }:

{
  home.username = "elmar";
  home.homeDirectory = "/home/elmar";
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 12;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    rustup
    prusa-slicer
    kicad
    krita
    blender
    inkscape
    telegram-desktop
    drawio
    picoscope
    kdePackages.kcolorchooser
    kdePackages.kgpg
    kdePackages.kruler
    virt-manager
    zellij

    neofetch

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    dhcping

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    wl-clipboard

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    lshw
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    gpu-viewer
  ];

  home.file = {
    "Projects/.directory".text = ''
      [Desktop Entry]
      Icon=folder-script
    '';
    # TODO: Check if the scdaemon config is required.
    ".gnupg/scdaemon.conf".text = ''
      reader-port Yubico Yubi
      disable-ccid
    '';
  };

  sshconfig.enable = true;

  firefox.enable = true;

  jetbrains = {
    defaultVmOptions = {
      minMemory = 4096;
      maxMemory = 8192;
      # awtToolkit = "wayland";
    };
    rustRover = {
      enable = true;
      version = "253.28294.188";
      checksum = "5f8002f44ff8d1b6f88e7c4a8fdd76c89898e6fcf61195dfe77a8d4be5afdd91";
      vmOptions.maxMemory = 16384;
      vmOptions.awtToolkit = "wayland";
    };
    intellij = {
      enable = true;
      version = "253.28294.251";
      checksum = "1cf4610b87aa04dfbf6c27abd0c869cd0259782b57e9c2b43a0e3ef7c3eb6328";
      vmOptions.awtToolkit = "wayland";
    };
    pycharm = {
      enable = true;
      version = "253.28294.256";
      checksum = "76c1cf285dcb9447a4f2942914974a66ac9ce04b80e32fcb42a9dbdfc2e76c50";
    };
  };

  git = {
    enable = true;
    userName = "Elmar Schug";
    userEmail = "elmar.schug@jayware.org";
  };

  helix.enable = true;

  eza.enable = true;

  konsole.enable = true;

  plasma.enable = true;

  zsh = {
    enable = true;
    plugins = [ "git" "rust" "docker" "kubectl" "helm" "argocd" "aws" "podman" ];
  };

  zellij = {
    enable = true;
  };

  alacritty = {
    enable = true;
  };

  wezterm = {
    enable = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
   };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.global.warn_timeout = "1h"; # https://github.com/direnv/direnv/blob/master/man/direnv.toml.1.md
  };

  programs.starship = {
    enable = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

