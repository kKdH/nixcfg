{ pkgs, ... }:

{
  home.username = "elmar";
  home.homeDirectory = "/home/elmar";
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd

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
  ];

  jetbrains = {
    defaultVmOptions = {
      minMemory = 4096;
      maxMemory = 8192;
      # awtToolkit = "wayland";
    };
    rustRover = {
      enable = false;
      vmOptions.maxMemory = 16384;
    };
    intellij = {
      enable = false;
      vmOptions.awtToolkit = "wayland";
    };
    pycharm = {
      enable = false;
    };
  };

  git = {
    enable = true;
    userName = "Elmar Schug";
    userEmail = "elmar.schug@jayware.org";
  };

  helix.enable = true;

  zsh = {
    enable = true;
    plugins = [ "git" "rust" "docker" "kubectl" "helm" "argocd" "aws" "podman" ];
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

