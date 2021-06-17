{ stdenv
, fetchurl
, mkfontscale
}:

stdenv.mkDerivation 
{
  name = "waffle-font";
  src = fetchurl 
  {
    url = "https://gitlab.com/dan4ik605743/dotfiles/-/raw/master/home/dan4ik/.local/share/fonts/waffle-10.bdf";
    sha256 = "0z4qm4v1rqfappd3zk8ycvvnxfny15p3s6gwd0ns2icy0vxkyvas";
  };
  dontUnpack = true;
  nativeBuildInputs =
  [
    mkfontscale
  ];
  installPhase = 
  ''
    mkdir -p $out/share/fonts/
    cp $src $out/share/fonts/
    cd "$out/share/fonts"
    mkfontdir
    mkfontscale
  '';
}
