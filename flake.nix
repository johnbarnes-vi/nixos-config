{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
	    system = "x86_64-linux";
	    pkgs = nixpkgs.legacyPackages.${system};
    in 
    {
      nixosConfigurations = {
        # Default NixOS Configuration 
        home = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/home/configuration.nix
            inputs.home-manager.nixosModules.default
            inputs.nixos-vscode-server.nixosModule
          ];
      	};

        # Workmachine NixOS Configuration
        # workmachine = nixpkgs.lib.nixosSystem {
          # specialArgs = {inherit inputs;};
          # modules = [
            # ./hosts/workmachine/configuration.nix
        #  ];
        # };
      };
    };
}
