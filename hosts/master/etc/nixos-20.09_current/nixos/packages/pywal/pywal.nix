{ stdenv 
, pywal
}:

stdenv.mkDerivation 
{
  name = "color-scheme";
  src = /etc/nixos/packages/pywal/.;
  buildInputs =
  [
    pywal
  ];
  unpackPhase =
  ''
    mkdir -p $out
    cp $src/wallpaper1 $out/background-image
  '';
  buildPhase =
  ''
    export HOME=$out
    wal -sent -i $out/background-image
  '';
  installPhase = 
  ''
    cp $out/.cache/wal/colors-putty.reg $out
    cp $out/.cache/wal/colors.json $out
    cp $out/.cache/wal/colors-rofi-dark.rasi $out
    cp $out/.cache/wal/colors.json $out/polybar.json
    sed -i 's/#/#aa/g' $out/polybar.json
    sed -i 's/background/background1/g' $out/polybar.json
    sed -i 's/foreground/foreground1/g' $out/polybar.json
    rm $out/.c*  -rf
  '';
}
