# nixcfg
My current — and always evolving — NixOS and Home Manager configurations.

## Usage

### Applying changes

```sh
sudo nixos-rebuild switch --flake . |& nom
```

### Optimisation and garbage collection

```sh
sudo nix store optimise
```

```sh
sudo nix-collect-garbage --delete-old
```
