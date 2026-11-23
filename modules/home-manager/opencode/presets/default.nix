{
  presets = {
    agents = import ./agents.nix;
    providers = import ./providers.nix;
    tools = import ./tools.nix;
  };
}
