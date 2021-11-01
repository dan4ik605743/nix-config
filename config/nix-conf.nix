{ inputs, system, nixpkgs }:

rec {
  package = nixpkgs.legacyPackages."${system}".nixFlakes;
  trustedBinaryCaches = binaryCaches;
  daemonNiceLevel = 1;
  daemonIONiceLevel = 1;
  maxJobs = 4;

  extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
    "nixos-config=/etc/nixos/hosts/ggwp/configuration.nix"
    "home-manager=${inputs.home}"
  ];

  trustedUsers = [
    "root"
    "dan4ik"
  ];

  binaryCaches = [
    "https://cache.nixos.org?priority=10"
    "https://cache.ngi0.nixos.org/"
    "https://emacsng.cachix.org"
    "https://mjlbach.cachix.org"
    "https://nix-community.cachix.org"
    "https://dan4ik605743.cachix.org"
  ];

  binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
    "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI="
    "mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "dan4ik605743.cachix.org-1:rhJb/S+2G33sj0wR2fXp0WqMKPCYHpeWG2AjS4dwUaA="
  ];

  registry = {
    system.flake = inputs.self;
    default.flake = inputs.nixpkgs;
    home-manager.flake = inputs.home;
  };

  optimise = {
    automatic = true;
    dates = [ "13:00" ];
  };

  gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };
}
