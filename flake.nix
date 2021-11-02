{
  description = "NixOS configuration using Nix Flakes";

  inputs = {
    # Flake inputs
    hardware.url = "github:nixos/nixos-hardware";
    home.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";

    # Nixpkgs branches
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-21.05";
    oldstable.url = "github:nixos/nixpkgs/nixos-20.09";

    # Default Nixpkgs for packages and modules
    nixpkgs.follows = "unstable";
  };

  outputs = { self, nixpkgs, hardware, home, nur, ... } @ inputs:
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
            # Nixpkgs branches
            unstable = import unstable { inherit config system; };
            stable = import stable { inherit config system; };
            oldstable = import oldstable { inherit config system; };
          })

        # Overlays provided by inputs
        nur.overlay
      ]
      # Overlays from ./overlays directory
      ++ (importNixFiles ./overlays);
    in
    {
      nixosConfigurations.ggwp = import ./hosts/ggwp {
        inherit config hardware home nur inputs nixpkgs overlays;
      };
    };
}