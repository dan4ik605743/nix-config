{ stdenv, pywal }:

stdenv.mkDerivation {
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
      cp $out/.cache/wal/colors.json $out/colors-gb.json
      cp $out/.cache/wal/colors-rofi-dark.rasi $out/colors-rofi-dark-gb.rasi
      sed '6 s/#111314/#282828/' -i $out/colors-gb.json
      sed '7 s/#ded6c8/#ebdbb2/' -i $out/colors-gb.json
      sed '11 s/#111314/#282828/' -i $out/colors-gb.json
      sed '12 s/#CEA13F/#cc241d/' -i $out/colors-gb.json
      sed '13 s/#999569/#98971a/' -i $out/colors-gb.json
      sed '14 s/#3D7983/#d79921/' -i $out/colors-gb.json
      sed '15 s/#B66C89/#458588/' -i $out/colors-gb.json
      sed '16 s/#5C908C/#b16286/' -i $out/colors-gb.json
      sed '17 s/#A79F8C/#689d6a/' -i $out/colors-gb.json
      sed '18 s/#ded6c8/#a89984/' -i $out/colors-gb.json
      sed '19 s/#9b958c/#928374/' -i $out/colors-gb.json
      sed '20 s/#CEA13F/#fb4934/' -i $out/colors-gb.json
      sed '21 s/#999569/#b8bb26/' -i $out/colors-gb.json
      sed '22 s/#3D7983/#fabd2f/' -i $out/colors-gb.json
      sed '23 s/#B66C89/#83a598/' -i $out/colors-gb.json
      sed '24 s/#5C908C/#d3869b/' -i $out/colors-gb.json
      sed '25 s/#A79F8C/#8ec07c/' -i $out/colors-gb.json
      sed '26 s/#ded6c8/#ebdbb2/' -i $out/colors-gb.json
      sed '24 s/#111314/#282828/' -i $out/colors-rofi-dark-gb.rasi
      sed '25 s/#ded6c8/#ebdbb2/' -i $out/colors-rofi-dark-gb.rasi
      rm $out/.c*  -rf
    '';
}
