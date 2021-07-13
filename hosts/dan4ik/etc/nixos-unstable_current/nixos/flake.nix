{
  description = "NixOS configuration using Nix Flakes";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-20.09";
    home.url = "github:nix-community/home-manager/release-21.05";
    nur.url = "github:nix-community/NUR";
    emacs.url = "github:nix-community/emacs-overlay";

    nixpkgs.follows = "unstable";
  };

  outputs = { self, nixpkgs, home, nur, ... } @ inputs:
    with nixpkgs.lib;
    let
      config = {
        allowBroken = true;
        allowUnfree = true;
      };
      overlays = with inputs; [
        (final: _:
          let
            system = final.stdenv.hostPlatform.system;
          in
          {
            stable = import stable { inherit config system; };
          })

        nur.overlay
        emacs.overlay
      ];
    in
    {
      nixosConfigurations.nixos = import ./system {
        inherit config home inputs nixpkgs overlays;
      };
    };
}
