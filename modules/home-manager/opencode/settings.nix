
{ lib, pkgs, ... }:

{
  autoshare ? false,
  autoupdate ? false,
  defaults ? {},
  agents ? {},
  providers ? {},
  ...
}:
let

  normalizePromptToFile = name: prompt:
    if builtins.isPath prompt
    then "{file:${prompt}}"
    else "{file:${pkgs.writeText "opencode-${name}-agent-prompt.txt" prompt}}";

  ocAgents = builtins.mapAttrs (name: agent: {
      description = if (agent.description or null) != null then agent.description else name;
      mode = agent.mode;
      color = agent.color;
    } // lib.optionalAttrs (agent.prompt != null) {
        prompt = normalizePromptToFile name agent.prompt;
    } // lib.optionalAttrs (agent.permissions != null) {
        permission = agent.permissions;
    } // lib.optionalAttrs (agent.temperature != null) {
        temperature = agent.temperature;
      #  "model": "anthropic/claude-sonnet-4-20250514",
    }) agents;

  ocProviders = builtins.mapAttrs (name: provider: {
    npm = provider.sdk;
    name = provider.displayName;
    options = {
      baseURL = provider.api.url;
    } // lib.optionalAttrs (provider.api.key != null) {
      apiKey = provider.api.key;
    };
    models = builtins.mapAttrs (name: model: {
      name = model.displayName;
    } // lib.optionalAttrs (model.cost != null) {
      cost = {
        input = model.cost.input;
        output = model.cost.output;
        #cache = { # Setting cache costs via config is not supported by OC.
        #  read = model.cost.cache_read;
        #  write = model.cost.cache_write;
        #};
      };
    }) provider.models;
  }) providers;

  ocEnabledProviders = builtins.attrNames providers;

  ocConfig = {
    "$schema" = "https://opencode.ai/config.json";
    autoshare = autoshare;
    autoupdate = autoupdate;
    disabled_providers = [];
    enabled_providers = ocEnabledProviders;
    agent = ocAgents;
    provider = ocProviders;
    plugin = [];
  } // lib.optionalAttrs ((defaults.agent or null) != null) {
    default_agent = defaults.agent;
  } // lib.optionalAttrs ((defaults.model or null) != null) {
    model = defaults.model;
  } // lib.optionalAttrs ((defaults.small_model or null) != null) {
    small_model = defaults.small_model;
  };
in
{
  json = builtins.toJSON ocConfig;
}
