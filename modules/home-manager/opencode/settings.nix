
{ lib, ... }:

{
  autoshare ? false,
  autoupdate ? false,
  providers ? {},
  ...
}:
let

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
      };
    }) provider.models;
  }) providers;

  ocConfig = {
    "$schema" = "https://opencode.ai/config.json";
    autoshare = autoshare;
    autoupdate = autoupdate;
    provider = ocProviders;
    plugin = [];
  };
in
{
  json = builtins.toJSON ocConfig;
}
