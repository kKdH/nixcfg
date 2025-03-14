{ pkgs, lib, config, ... }:

{
  imports = [
    ./firefox/default.nix
    ./git.nix
    ./helix.nix
    ./jetbrains.nix
    ./plasma.nix
    ./zsh.nix
  ];
}
