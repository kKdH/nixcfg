{ lib, config, pkgs, ... }:

let
  cfg = config.vibe;

  # Patch upstream mistral-vibe to skip tests that cannot be executed in Nix's sandbox.
  vibe-patched = pkgs.mistral-vibe.overrideAttrs (old: {
    disabledTests = (old.disabledTests or []) ++ [
      "test_steer_requests_invoked_skill_injection"
    ];
  });

in
{
  options.vibe = {
    enable = lib.mkEnableOption "Mistral Vibe CLI coding agent";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ vibe-patched ];
  };
}
