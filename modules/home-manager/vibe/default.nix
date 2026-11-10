{ lib, config, pkgs, ... }:

let
  cfg = config.vibe;

  # Build requires aws-lc package because cargoSetupHook sets AWS_LC_SYS_USE_SYSTEM=1
  mistral-vibe = pkgs.mistral-vibe.overrideAttrs (old: {
    passthru = old.passthru // {
      vibe-rs = old.passthru.vibe-rs.overrideAttrs (vibeOld: {
        buildInputs = (vibeOld.buildInputs or [ ]) ++ [ pkgs.aws-lc ];
      });
    };
  });
in
{
  options.vibe = {
    enable = lib.mkEnableOption "Mistral Vibe CLI";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      mistral-vibe
    ];
  };
}
