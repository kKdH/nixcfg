# FreeCAD module — supports building from a custom git tag (weekly or stable).
#
# Weekly update workflow:
#   1. Find latest weekly tag at https://github.com/FreeCAD/FreeCAD/releases
#   2. Fetch new hash (submodules required):
#        nix run nixpkgs#nix-prefetch-github -- --fetch-submodules FreeCAD FreeCAD --rev weekly-YYYY.MM.DD
#   3. Update home.nix:
#        tag     = "weekly-YYYY.MM.DD";
#        version = "<version from freecadcmd --version output>";
#        srcHash       = "<hash from step 2>";
#   4. Rebuild:
#        nixos-rebuild switch --flake .#c415lx084833926
#
# Note: FreeCAD builds from source (~15 min with many cores, 2-3h without).
# No binary cache entry exists for weekly tags.

{ lib, config, pkgs, ... }:

let
  cfg = config.freecad;

  freecad-custom = pkgs.freecad.overrideAttrs (old: {
    version = cfg.version;
    src = pkgs.fetchFromGitHub {
      owner = "FreeCAD";
      repo = "FreeCAD";
      tag = cfg.tag;
      hash = cfg.srcHash;
      fetchSubmodules = true;
    };
    # Drop the coin3d fetchpatch — merged upstream in >= 1.1.2
    # Keep only the NixOS PYTHONPATH patch
    patches = lib.filter
      (p: !(lib.isDerivation p))
      (old.patches or []);

    # Weekly builds require GTest which is not in the nixpkgs 1.1.1 expression.
    # Add it; disable test execution to keep build times reasonable.
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.gtest ];
    cmakeFlags = (old.cmakeFlags or []) ++ [ "-DBUILD_TESTING=OFF" ];
  });

in
{
  options.freecad = {
    enable = lib.mkEnableOption "Enable FreeCAD";

    weekly = lib.mkEnableOption "Build FreeCAD from a custom tag (weekly or stable) instead of nixpkgs version";

    version = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1";
      example = "26.3.0";
      description = "Version string reported by freecadcmd --version. Used as the nix version attr so versionCheckPhase passes.";
    };

    tag = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1";
      example = "weekly-2026.08.05";
      description = "Git tag to fetch from FreeCAD/FreeCAD on GitHub.";
    };

    srcHash = lib.mkOption {
      type = lib.types.str;
      # nixpkgs 1.1.1 hash — update when bumping tag (see workflow comment at top)
      # Get new hash: nix run nixpkgs#nix-prefetch-github -- --fetch-submodules FreeCAD FreeCAD --rev <tag>
      default = "sha256-7/VEbs8YDM1Xwc819ab6av5fgRSIbbB6LeCM0V08vRU=";
      description = "SRI hash for fetchFromGitHub (must include submodules).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (if cfg.weekly then freecad-custom else pkgs.freecad)
    ];
  };
}
