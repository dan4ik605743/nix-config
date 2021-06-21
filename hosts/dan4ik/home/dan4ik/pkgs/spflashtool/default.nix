{ stdenv
, fetchurl
, unzip
, autoPatchelfHook
, gcc-unwrapped
, libpng12
, libjpeg
, fontconfig
, freetype
, zlib
, glib
, glibc
, xlibs
, libmng
, qt4
}:
stdenv.mkDerivation rec
{
  pname = "spflashtools";
  version = "5.2112";
  src = fetchurl {
    url = "http://spflashtools.com/wp-content/uploads/SP_Flash_Tool_v${version}_Linux.zip";
    sha256 = "1l5iwjpss3wjl1d8dndsb87j9b7x4p2gcrdbxql87mfcmwbdxax3";
  };
  autoPatchelfIgnoreMissingDeps = true;
  dontWrapQtApps = true;
  nativeBuildInputs =
    [
      unzip
      autoPatchelfHook
    ];
  buildInputs =
    [
      qt4
      libmng.out
      gcc-unwrapped
      fontconfig
      freetype
      libpng12
      libjpeg
      glib
      glibc
      zlib
      xlibs.libX11
      xlibs.libXext
      xlibs.libXrender
      xlibs.libICE
      xlibs.libSM
    ];
  installPhase =
    ''
      mkdir $out -p
      cp /build/*/* $out -r
      chmod +x $out/flash_tool
    '';
}
