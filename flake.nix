{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spacenav-rs = {
      url = "github:kkdh/spacenav-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rusty-nix = {
      url = "github:kKdH/hello-rusty-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ 
      self,
      nixpkgs,
      nixpkgs-stable,
      sops-nix,
      home-manager,
      plasma-manager,
      impermanence,
      spacenav-rs,
      rusty-nix,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      #
      # c415lx084833926
      #
      nixosConfigurations.c415lx084833926 = nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs;
        };
        modules = [
          {
            imports = [
              ./hosts/c415lx084833926/configuration.nix
              ./modules/nixos
              impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
            ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.elmar = import ./hosts/c415lx084833926/home.nix;
              extraSpecialArgs = specialArgs;
              sharedModules = [
                sops-nix.homeManagerModules.sops
                plasma-manager.homeModules.plasma-manager
                ./modules/home-manager
              ];
            };
          }
        ];
      };
      #
      # fuji
      #
      nixosConfigurations.fuji = nixpkgs.lib.nixosSystem(
      let
        system = "x86_64-linux";
      in
      {
        modules = [
          {
            imports = [
              ./hosts/fuji/configuration.nix
              ./modules/nixos
              impermanence.nixosModules.impermanence
              home-manager.nixosModules.home-manager
              rusty-nix.nixosModules."${system}".rusty-nix
            ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.elmar = import ./hosts/fuji/home.nix;
              sharedModules = [
                sops-nix.homeManagerModules.sops
                plasma-manager.homeModules.plasma-manager
                ./modules/home-manager
              ];
            };
          }
        ];
      });
    };
}

