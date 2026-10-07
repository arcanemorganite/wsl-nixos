{

inputs = {
	# Nixpkgs
	nixpkgs.url = "github:nixos/nixpkgs/release-26.05";

	# Home manager !
	home-manager = {
	  url = "github:nix-community/home-manager/release-26.05";
	  inputs.nixpkgs.follows = "nixpkgs";
	};

	nixvim = {
	  url = "github:nix-community/nixvim/nixos-26.05";
	  inputs.nixpkgs.follows = "nixpkgs";
	};

  };

  outputs = {
	nixpkgs,
	home-manager,
	...
	} @ inputs: let
	in {
	  # NixOS configuration entrypoint
	  nixosConfigurations = {
		nixos = nixpkgs.lib.nixosSystem {
		  specialArgs = {inherit inputs;};
		  modules = with inputs; [
			./nixos/configuration.nix
		  ];
		};

		neo = nixpkgs.lib.nixosSystem {
		  specialArgs = {inherit inputs;};
		  # > Our main nixos configuration file <
		  modules = with inputs; [
			./nixos/neo/neo.nix
		  ];
		};
	  };

	  # Standalone home-manager configuration entrypoint
	  homeConfigurations = {
		"morgan@nixos" = home-manager.lib.homeManagerConfiguration {
		  # Home-manager requires 'pkgs' instance
		  pkgs = nixpkgs.legacyPackages.x86_64-linux; # FIXME replace x86_64-linux with your architecure 
		  extraSpecialArgs = {inherit inputs;};
		  # > Our main home-manager configuration file <
		  modules = [
			./home-manager/home.nix
		  ];
		};
	  };
	};
}
