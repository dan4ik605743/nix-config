{ config, home, inputs, nixpkgs, overlays, ... }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    home.nixosModules.home-manager
    nixpkgs.nixosModules.notDetected

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.dan4ik = import ./home.nix;
      };
      nixpkgs = { inherit config overlays; };
    }

    ./configuration.nix
    ./hardware-configuration.nix
    ./kernel.nix
  ];

  specialArgs = { inherit inputs; };
}
