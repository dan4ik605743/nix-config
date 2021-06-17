{}:

with import <nixpkgs> {};

let
  wvstreams = callPackage ./wvstreams.nix {}; 
in
stdenv.mkDerivation
{
  name = "wvdial";
  src = fetchurl
  {
    url = "https://archlinux.org/packages/community/x86_64/wvdial/download/";
    sha256 = "11xcnkpv5zsgx30ff6flp3gwl7wigqf8p4g7d1plw6jbg52npja6";
  };
  unpackPhase = 
  ''
    mkdir -p $out/bin
    tar -I zstd -xvf $src -C $out
  '';
  nativeBuildInputs =
  [
    zstd
    autoPatchelfHook
  ];
  buildInputs =
  [
    ppp
    gcc-unwrapped
    wvstreams
  ];
  installPhase = 
  ''
    mv $out/usr/bin/* $out/bin
  '';
}
