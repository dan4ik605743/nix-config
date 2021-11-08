{ config, home, nur, inputs, nixpkgs, overlays, ... }:

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

      imports =
        let
          nur-modules = import nur {
            nurpkgs = import nixpkgs { system = "x86_64-linux"; };
          };
        in
        [ ];

      nixpkgs = { inherit config overlays; };
    }

    ./configuration.nix
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
  ];

  specialArgs = { inherit inputs; };
}
