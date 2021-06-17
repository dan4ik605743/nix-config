{ pkgs ? import <nixpkgs> {} 
}:

pkgs.mkShell {
  shellHook =
  ''
    nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'
    sudo result/bin/kdiskmark
  '';
  buildInputs = 
  [
    pkgs.fio
  ];
}
