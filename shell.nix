{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [
    autoPatchelfHook
    bintools-unwrapped
    dpkg
  ];
}
