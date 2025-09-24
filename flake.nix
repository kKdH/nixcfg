{
  description = "My NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";
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
    rusty-nix = {
      url = "github:kKdH/hello-rusty-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    picoscope-nixpkgs = {
      url = "github:NixOS/nixpkgs/ea5c3d756e0f001f46560e99afb3cd3e954ae2cb";
      # url = "github:SteveBinary/nixpkgs/master";
      # url = "github:tshakah/nixpkgs/15f635f5356f434d65291b921f2b696a588661dd";
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
      rusty-nix,
      picoscope-nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.c415lx084833926 = nixpkgs.lib.nixosSystem rec {
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          picoscope-pkgs = import picoscope-nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          ./hosts/c415lx084833926/configuration.nix
          ./modules/nixos
          impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.elmar = import ./hosts/c415lx084833926/home.nix;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
              plasma-manager.homeModules.plasma-manager
              impermanence.homeManagerModules.impermanence
              ./modules/home-manager
            ];
          }
        ];
      };
      nixosConfigurations.fuji = nixpkgs.lib.nixosSystem(
      let
        system = "x86_64-linux";
      in
      {
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
              plasma-manager.homeModules.plasma-manager
              ./modules/home-manager
            ];
          }
          rusty-nix.nixosModules."${system}".rusty-nix
        ];
      });
    };
}

