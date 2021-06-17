{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation 
{
  name = "my-cursor";
  src = fetchFromGitHub 
  {
    owner = "dan4ik605743";
    repo = "lyra-cursors";
    rev = "9acd8dc2988eb0bcaf30ddf48cfea0085b64dc4a";
    sha256 = "137l6kfl46x1p096f17hxpnxv74mji01bm156llfm5470vzmj5dc";
  };
  installPhase = 
  ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Lyra{B,F,G,P,Q,X}-cursors $out/share/icons/
  '';
}
