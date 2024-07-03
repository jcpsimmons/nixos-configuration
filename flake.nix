{
  description = "Home Manager configuration of Jane Doe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem(system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      {
        # nix run home-manager -- switch --flake '.#workMac' -b bak
        packages.homeConfigurations.workMac = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home.nix ./packages/mac.nix ];

          extraSpecialArgs = {
            username = "jsimmons";
            homeDirectory = "/Users/jsimmons";
            outputName = "workMac"; # there's probably a better way to get this
            };
        };
      }
    );
}
