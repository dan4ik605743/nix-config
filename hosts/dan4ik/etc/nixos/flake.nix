{
  description = "NixOS configuration using Nix Flakes";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-21.05";
    oldstable.url = "github:nixos/nixpkgs/nixos-20.09";
    home.url = "github:nix-community/home-manager";
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
      filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;
      importNixFiles = path: (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
        (filterAttrs filterNixFiles (builtins.readDir path)))) import;
      overlays = with inputs; [
        (final: _:
          let
            system = final.stdenv.hostPlatform.system;
          in
          {
            unstable = import unstable { inherit config system; };
            stable = import stable { inherit config system; };
            oldstable = import oldstable { inherit config system; };
          })

        nur.overlay
        emacs.overlay
      ] ++ (importNixFiles ./system/overlays);
    in
    {
      nixosConfigurations.nixos = import ./system {
        inherit config home nur inputs nixpkgs overlays;
      };
    };
}
