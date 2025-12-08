{ pkgs, ... }:

{
  home.username = "elmar";
  home.homeDirectory = "/home/elmar";
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 12;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    kicad
    picoscope
    zellij
    zip
    xz
    unzip
    p7zip
    ripgrep
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    wl-clipboard

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

  git = {
    enable = true;
    userName = "Elmar Schug";
    userEmail = "elmar.schug@jayware.org";
  };

  helix.enable = true;

  jetbrains = {
    rustRover = {
      enable = false;
     };
    intellij = {
      enable = false;
     };
    pycharm = {
      enable = false;
    };
  };

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

