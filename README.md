<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="./images/nixos-logo-dark.svg" />
    <source media="(prefers-color-scheme: light)" srcset="./images/nixos-logo-light.svg" />
    <img alt="NixOS Logo" src="./images/nixos-logo-light.svg" />
  </picture>
</p>

# nixcfg
My current — and always evolving — [NixOS](https://nixos.org/) and [Home Manager](https://github.com/nix-community/home-manager) configurations.

## Usage

### Applying changes

```sh
sudo nixos-rebuild switch --flake . --option corse 16 |& nom
```

### Optimisation and garbage collection

```sh
sudo nix store optimise
```

```sh
sudo nix-collect-garbage --delete-old
```
