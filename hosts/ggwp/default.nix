{ config, hardware, home, nur, agenix, inputs, nixpkgs, overlays, ... }:

nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  modules = [
    agenix.nixosModules.age
    home.nixosModules.home-manager
    hardware.nixosModules.common-pc-ssd
    nixpkgs.nixosModules.notDetected

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.dan4ik = import ../../users/dan4ik/default.nix;
      };

      age = {
        secrets.secrets.file = ../../secrets/secrets.age;
        identityPaths = [ "/home/dan4ik/.ssh/id_ed25519" ];
      };

      imports =
        let
          nur-modules = import nur {
            nurpkgs = import nixpkgs { system = system; };
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
