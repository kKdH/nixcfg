{ pkgs, inputs, config, opencode, ... }:

{
  home.username = "elmar";
  home.homeDirectory = "/home/elmar";
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  home.file = {
    # Suppress kwin opengl loggs due to: https://bugs.kde.org/show_bug.cgi?id=511852
    # Or set nvidia card as first device: https://bbs.archlinux.org/viewtopic.php?pid=2275751#p2275751
    # which shifts composing to the dedicated GPU (GPU will be active all the time)
    ".config/systemd/user/plasma-kwin_wayland.service.d/override.conf".text = ''
      [Service]
      # Environment=QT_LOGGING_RULES=kwin_scene_opengl=false
      # Environment=KWIN_DRM_DEVICES=/dev/dri/card0:/dev/dri/card1
    '';
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

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    # Secrets to decrypt
    secrets = {
      anthropicApiKey = {};
      anthropicBaseUrl = {};
      googleApiKey = {};
      googleBaseUrl = {};
      moonshotApiKey = {};
      moonshotBaseUrl = {};
      mistralApiKey = {};
      mistralBaseUrl = {};
      zhipuApiKey = {};
      zhipuBaseUrl = {};
    };
  };

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 12;
    "Xft.dpi" = 172;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    rustup
    krita
    blender
    inkscape
    telegram-desktop
    drawio
    picoscope
    kdePackages.kcolorchooser
    kdePackages.kgpg
    kdePackages.krdc
    kdePackages.kruler
    kdePackages.kdeconnect-kde
    kubectl
    virt-manager
    zellij
    spnavcfg
    inputs.spacenav-rs.packages.${pkgs.system}.default
    # mistral-vibe
    scrcpy
    zed-editor
    lazygit
    # qgis # Geographic Information System # TODO: enable when pdal build is fixed.
    solaar # Device manager for many Logitech products.
    github-cli
    jetbrains-toolbox
    teams-for-linux
    difftastic

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
    nixd # nix LSP

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

  opencode = {
    enable = true;
    skills = [ "caveman" ];
    commands = [ "caveman" ];
    defaults = {
      agent = "plan";
      model = "mistral/mistral-medium-latest";
      small_model = "mistral/mistral-medium-latest";
    };
    agents = {
      build = opencode.presets.agents.build;
      debug = opencode.presets.agents.debug;
      plan = opencode.presets.agents.plan;
      teach = opencode.presets.agents.teach;
      brainstorm = opencode.presets.agents.brainstorm;
    };
    providers = {
      anthropic = opencode.presets.providers.anthropic // {
        api.url = "{file:${config.sops.secrets.anthropicBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.anthropicApiKey.path}}";
      };
      google = opencode.presets.providers.google // {
        api.url = "{file:${config.sops.secrets.googleBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.googleApiKey.path}}";
      };
      mistral = opencode.presets.providers.mistral // {
        api.url = "{file:${config.sops.secrets.mistralBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.mistralApiKey.path}}";
      };
      moonshot = opencode.presets.providers.moonshot // {
        api.url = "{file:${config.sops.secrets.moonshotBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.moonshotApiKey.path}}";
      };
      ollama = opencode.presets.providers.ollama;
      zhipu = opencode.presets.providers.zhipu // {
        api.url = "{file:${config.sops.secrets.zhipuBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.zhipuApiKey.path}}";
      };
    };
  };

  sshconfig.enable = true;

  firefox.enable = true;

  freecad = {
    enable = true;
    weekly = true;
    tag = "weekly-2026.08.26";
    version = "26.3.0";
    # Update hash: nix run nixpkgs#nix-prefetch-github -- --fetch-submodules FreeCAD FreeCAD --rev <tag>
    # sha256-lXcHg86qkDAZcC5xv013gEvY+mfAtz+v9NadWU3/7SA=
    srcHash = "sha256-H0P2V01kA4cNMV4KcRS0xMsRTLV/Ez9lzZ6tQTDj2GQ=";
  };

  kicad.enable = true;

  jetbrains = {
    defaultVmOptions = {
      minMemory = 4096;
      maxMemory = 8192;
      # awtToolkit = "wayland";
    };
    rustRover = {
      enable = true;
#      version = "2026.1.4";
#      checksum = "f31fc03fab8a49525abf08c0f6d613d48335c55b29399673c26730a4696821cc";
      version = "2026.2.1";
      checksum = "fd7baa32a6b29cf867bb8afc05ec001e1fca7408278192541611bd5d3f482f5b";
#      version = "262.8377.49";
#      checksum = "f0ce574fb25e2fbd2b4fa2832e7795f0fb7551aee70da2b372bed389ebf7633a";
      vmOptions.maxMemory = 16384;
      vmOptions.awtToolkit = "wayland";
    };
    intellij = {
      enable = true;
      version = "2026.2.0.1";
      checksum = "914e31e31b4e1285d538cf3fae5b300af08bcff36bc298ac6200504bbe12f180";
      vmOptions.maxMemory = 16384;
      vmOptions.awtToolkit = "wayland";
    };
    pycharm = {
      enable = true;
#      version = "262.8377.41";
#      checksum = "cqZ1m1ykYmw2Be6ZzBZp4U1ofSt4FHueri2t5Ihsnew=";
      version = "2026.2.1";
      checksum = "9cff6f18ec28a3d51643bcf47f001bed194260185fa6f5693f5a6f83cebae868";
      vmOptions.awtToolkit = "wayland";
    };
  };

  bacon = {
    enable = true;
  };

  git = {
    enable = true;
    userName = "Elmar Schug";
    userEmail = "elmar.schug@jayware.org";
  };

  helix.enable = true;

  litellm = {
    enable = false;
    service.enable = true;
  };

  bat.enable = true;
  eza.enable = true;

  konsole.enable = true;

  plasma.enable = true;

  zsh = {
    enable = true;
    plugins = [ "git" "rust" "docker" "kubectl" "helm" "argocd" "aws" "podman" ];
    aliases = {
      "oc" = "opencode";
    };
  };

  zellij = {
    enable = true;
  };

  wezterm = {
    enable = true;
  };

  prusa-slicer = {
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
  home.stateVersion = "26.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}

