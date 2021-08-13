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
      nixpkgs = { inherit config overlays; };
      imports =
        let
          nur-modules = import nur {
            nurpkgs = import nixpkgs { system = "x86_64-linux"; };
          };
        in
        [
          nur-modules.repos.dan4ik605743.modules.emacs
        ];
    }

    ./configuration.nix
    ./hardware-configuration.nix
  ];

  specialArgs = { inherit inputs; };
}
