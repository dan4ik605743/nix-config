{ stdenv
, pywal
}:

stdenv.mkDerivation
{
  name = "color-scheme";
  src = ./.;
  buildInputs =
    [
      pywal
    ];
  unpackPhase =
    ''
      mkdir -p $out
      cp $src/current $out/background-image
    '';
  buildPhase =
    ''
      export HOME=$out
      wal -sent -i $out/background-image
    '';
  installPhase =
    ''
      cp $out/.cache/wal/colors.json $out
      cp $out/.cache/wal/colors-rofi-dark.rasi $out
      rm $out/.c*  -rf
    '';
}
