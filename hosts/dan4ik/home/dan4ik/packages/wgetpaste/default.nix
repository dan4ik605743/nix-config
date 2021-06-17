{ stdenv, fetchFromGitHub, }:

stdenv.mkDerivation {
  name = "wgetpaste";
  src = fetchFromGitHub {
    owner = "dan4ik605743";
    repo = "wgetpaste";
    rev = "d21d3ba57c1c70b18cce1a41f24da044073f51eb";
    sha256 = "0a7g1rbcp5l2928ri3vzsr3n27rr0lcwvya0l2g93ib8jlgq8my2";
  };
  installPhase = ''
    install -D wgetpaste --target-directory=$out/bin/
    '';
}
