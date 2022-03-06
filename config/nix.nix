{ inputs, system, nixpkgs }:

rec {
  package = nixpkgs.legacyPackages."${system}".nix;
 
  extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixPath =
    let
      path = toString ../.;
    in
    [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=/etc/nixos/hosts/ggwp/configuration.nix"
      "home-manager=${inputs.home}"
      "repl=${path}/repl.nix"
    ];

  registry = {
    system.flake = inputs.self;
    default.flake = inputs.nixpkgs;
    home-manager.flake = inputs.home;
  };

  settings = rec {
    max-jobs = 1;
    trusted-substituters = substituters;

    trusted-users = [
      "root"
      "dan4ik"
    ];

    substituters = [
      "https://cache.nixos.org?priority=10"
      "https://cache.ngi0.nixos.org/"
      "https://nix-community.cachix.org"
      "https://dan4ik605743-nur.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "dan4ik605743-nur.cachix.org-1:emiEpwGzec0g1z5juvp8i1aqe1W5hICsLauv9UZ6OJw="
    ];
  };
}
