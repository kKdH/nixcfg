{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{ 
      self,
      nixpkgs,
      sops-nix,
      home-manager,
      plasma-manager,
      impermanence,
      ...
    }: {
      nixosConfigurations.c415lx084833926 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/c415lx084833926/configuration.nix
          ./modules/nixos
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elmar = import ./hosts/c415lx084833926/home.nix;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
              plasma-manager.homeManagerModules.plasma-manager
              ./modules/home-manager
            ];
          }
        ];
      };
      nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/fuji/configuration.nix
          ./modules/nixos
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elmar = import ./hosts/fuji/home.nix;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
              plasma-manager.homeManagerModules.plasma-manager
              ./modules/home-manager
            ];
          }
        ];
      };
    };
}

