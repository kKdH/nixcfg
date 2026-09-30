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
      mistralApiKey = {};
      mistralBaseUrl = {};
      moonshotApiKey = {};
      moonshotBaseUrl = {};
      nxAnthropicApiKey = {};
      nxAnthropicBaseUrl = {};
      nxGoogleApiKey = {};
      nxGoogleBaseUrl = {};
      nxMoonshotApiKey = {};
      nxMoonshotBaseUrl = {};
      nxOpenaiApiKey = {};
      nxOpenaiBaseUrl = {};
      nxZhipuApiKey = {};
      nxZhipuBaseUrl = {};
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
      proofread = opencode.presets.agents.proofread;
      codemate = opencode.presets.agents.codemate;
    };
    providers = {
      mistral = opencode.presets.providers.mistral // {
        api.url = "{file:${config.sops.secrets.mistralBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.mistralApiKey.path}}";
      };
      moonshot = opencode.presets.providers.moonshot // {
        api.url = "{file:${config.sops.secrets.moonshotBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.moonshotApiKey.path}}";
      };
      nx-anthropic = opencode.presets.providers.nx-anthropic // {
        api.url = "{file:${config.sops.secrets.nxAnthropicBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.nxAnthropicApiKey.path}}";
      };
      nx-google = opencode.presets.providers.nx-google // {
        api.url = "{file:${config.sops.secrets.nxGoogleBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.nxGoogleApiKey.path}}";
      };
      nx-moonshot = opencode.presets.providers.nx-moonshot // {
        api.url = "{file:${config.sops.secrets.nxMoonshotBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.nxMoonshotApiKey.path}}";
      };
      nx-zhipu = opencode.presets.providers.nx-zhipu // {
        api.url = "{file:${config.sops.secrets.nxZhipuBaseUrl.path}}";
        api.key = "{file:${config.sops.secrets.nxZhipuApiKey.path}}";
      };
      ollama = opencode.presets.providers.ollama;
    };
  };

  sshconfig.enable = true;

  firefox.enable = true;

  freecad = {
    enable = true;
    weekly = true;
    tag = "weekly-2026.09.23";
    version = "26.3.0";
    # Update hash: nix run nixpkgs#nix-prefetch-github -- --fetch-submodules FreeCAD FreeCAD --rev <tag>
    srcHash = "sha256-WIv7HcO5pkfm6p4Kd8aSRY/e8ra9E2ACpLVE/KqLpXY=";
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
      version = "2026.2.3";
      checksum = "fac0d50307301ecdb69998feeb338f1287a96e9c02d205165ec4e1d8c0ed40a6";
#      version = "262.8377.49";
#      checksum = "f0ce574fb25e2fbd2b4fa2832e7795f0fb7551aee70da2b372bed389ebf7633a";
      vmOptions.maxMemory = 16384;
      vmOptions.awtToolkit = "wayland";
    };
    intellij = {
      enable = true;
      version = "2026.2.2";
      checksum = "f1cc5329a7adf3ab3bd8886744103f7d3bcf1ca12e699762ecd9bffe57335f8b";
      vmOptions.maxMemory = 16384;
      vmOptions.awtToolkit = "wayland";
    };
    pycharm = {
      enable = true;
#      version = "262.8377.41";
#      checksum = "cqZ1m1ykYmw2Be6ZzBZp4U1ofSt4FHueri2t5Ihsnew=";
      version = "2026.2.2";
      checksum = "60448e3fb4e6a700e3d2ad3583ea8de1505b3f436e6715329a5a35e31c34aced";
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
    # revision = "version_2.9.6";
    revision = "version_3.0.0-alpha12";
    srcHash = "sha256-T40R+K9h2o5QyAiLPQAnL/yx3HLzHWtgh0e8t3D1DHY=";
  };

  vibe.enable = false;

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

