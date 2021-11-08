{ config, hardware, home, nur, inputs, nixpkgs, overlays, ... }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    home.nixosModules.home-manager
    hardware.nixosModules.common-pc-ssd
    nixpkgs.nixosModules.notDetected

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.dan4ik = import ../../users/dan4ik/default.nix;
      };

      imports =
        let
          nur-modules = import nur {
            nurpkgs = import nixpkgs { system = "x86_64-linux"; };
          };
        in
        [ ];

      nix = import ../../config/nix.nix { inherit inputs system nixpkgs; };
      nixpkgs = { inherit config overlays; };
    }

    ./configuration.nix
    ./hardware-configuration.nix
  ];

  specialArgs = { inherit inputs; };
}
