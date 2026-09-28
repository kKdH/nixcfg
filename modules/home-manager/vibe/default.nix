{ lib, config, pkgs, ... }:

let
  cfg = config.vibe;

  # Patch upstream mistral-vibe to skip tests that cannot be executed in Nix's sandbox.
  vibe-patched = pkgs.mistral-vibe.overrideAttrs (old: {
    disabledTests = (old.disabledTests or []) ++ [
      "test_steer_requests_invoked_skill_injection"
      "test_install_succeeds_when_uv_bin_dir_is_already_on_path"
      "test_install_reports_missing_path_for_uv_tool_bin"
      "test_install_fails_when_vibe_not_in_uv_tool_dir"
      "test_update_succeeds_when_vibe_is_already_on_path"
      "test_pause_after_double_click_resets_to_char"
      "test_click_chain_loops_after_triple_click"
      "test_jitter_within_word_does_not_break_click_chain"
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
