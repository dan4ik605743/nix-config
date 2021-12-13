{
  description = "NixOS configuration using Nix Flakes";

  inputs = {
    hardware.url = "github:nixos/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    home.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";

    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-21.11";
    oldstable.url = "github:nixos/nixpkgs/nixos-20.09";

    nixpkgs.follows = "unstable";
  };

  outputs = { self, nixpkgs, hardware, home, nur, agenix, ... } @ inputs:
    with nixpkgs.lib;
    let
      system = "x86_64-linux";
      pkgs = mkPkgs nixpkgs [ self.overlay ];

      filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;
      importNixFiles = path: (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
        (filterAttrs filterNixFiles (builtins.readDir path)))) import;

      config = {
        allowBroken = true;
        allowUnfree = true;
      };

      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config = config;
      };

      overlays = with inputs; [
        (final: _:
          let
            system = final.stdenv.hostPlatform.system;
          in
          {
            agenix = agenix.defaultPackage.${system};

            unstable = import unstable { inherit config system; };
            stable = import stable { inherit config system; };
            oldstable = import oldstable { inherit config system; };
          })

        nur.overlay
      ] ++ (importNixFiles ./overlays);
    in
    {
      nixosConfigurations.ggwp = import ./hosts/ggwp {
        inherit config hardware home nur agenix inputs nixpkgs overlays;
      };

      ggwp = self.nixosConfigurations.ggwp.config.system.build.toplevel;

      nixosConfigurations.iso = import ./iso {
        inherit config home nur inputs nixpkgs overlays;
      };

      iso = self.nixosConfigurations.iso.config.system.build.isoImage;

      devShell.${system} = import ./shell.nix { inherit pkgs; };
    };
}
