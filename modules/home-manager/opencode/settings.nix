
{ lib, pkgs, ... }:

{
  autoshare ? false,
  autoupdate ? false,
  defaults ? {},
  agents ? {},
  providers ? {},
  mcp ? {},
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
    } // lib.optionalAttrs (agent.temperature != null) {
        temperature = agent.temperature;
    } // {
      permissions = agent.permissions
        ++ lib.optionals (agent.tools != null) (map (tool: {
          action = tool;
          resource = "*";
          effect = "allow";
        }) (lib.attrNames (lib.filterAttrs (_: enabled: enabled) agent.tools)));
    }
  ) agents;

  ocProviders = builtins.mapAttrs (name: provider:
    { name = provider.displayName; }
    // lib.optionalAttrs (provider.sdk != null) {
      package = provider.sdk;
    } // {
      settings = {
        baseURL = provider.api.url;
      } // lib.optionalAttrs (provider.api.key != null) {
        apiKey = provider.api.key;
      } // provider.settings;
      models = builtins.mapAttrs (
        name: model:
        {
          name = model.displayName;
        }
        // lib.optionalAttrs (model.capabilities != null) {
          capabilities = model.capabilities;
        }
        // lib.optionalAttrs (model.cost != null) {
          cost = {
            input = model.cost.input;
            output = model.cost.output;
          } // lib.optionalAttrs (model.cost.cache != null) {
            cache = model.cost.cache;
          };
        }
        // lib.optionalAttrs (model.limit != null) {
          limit = model.limit;
        }
      ) provider.models;
    }) providers;

  ocEnabledProviders = builtins.attrNames providers;

  ocMcp = {
    servers = {
      github = {
        type = "remote";
        url = "https://api.githubcopilot.com/mcp/";
        disabled = !mcp.github.enable;
        oauth = false;
        headers = {
          Authorization = "Bearer ${mcp.github.pat}";
        };
      };
    };
  };

  ocPermissions = [
    # Disable all github tool by default. enable selectively per agent.
    { action = "github_*"; resource = "*"; effect = "deny"; }
  ];

  ocConfig = {
    "$schema" = "https://opencode.ai/config.json";
    autoshare = autoshare;
    autoupdate = autoupdate;
    disabled_providers = [];
    enabled_providers = ocEnabledProviders;
    agents = ocAgents;
    providers = ocProviders;
    plugins = [];
    mcp = ocMcp;
    permissions = ocPermissions;
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
