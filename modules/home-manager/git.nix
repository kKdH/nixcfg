{ pkgs, lib, config, ... }:

{
  options = {
    git.enable = lib.mkEnableOption "Enable Git";
    git.userName = lib.mkOption {
      type = lib.types.str;
    };
    git.userEmail = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.git.enable {
    home.packages = [
      pkgs.git-lfs
    ];
    programs.git = {
      enable = true;
      lfs.enable = true;
      difftastic.enable = true;
      settings = {
        user.name = config.git.userName;
        user.email = config.git.userEmail;
        core.autocrlf = "false";
        init.defaultBranch = "main";
        safe.directory = "*";
        difftool.prompt = false; # Run the difftool immediately, don't ask 'are you sure' each time.
        pager.difftool = true; # Use a pager if the difftool output is larger than one screenful.
        diff.tool = "difft"; # Set difftastic as the default difftool.
      };
    };
  };
}
