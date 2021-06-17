{ stdenv, fetchFromGitHub, xcursorgen }:

stdenv.mkDerivation {
  name = "my-cursor";
  src = fetchFromGitHub {
    owner = "dan4ik605743";
    repo = "cursor";
    rev = "09eedf5667b3f07a1424f1a09326f98bcdc98e8c";
    sha256 = "1rkx5g5gkidd2qwjmq6n1rjafanh4syypg881kyjmckvj6jar30m";
  };
  installPhase = 
  ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' LyraG-cursors $out/share/icons/
  '';
  nativeBuildInputs = 
  [ 
    xcursorgen
  ];
}
