{ stdenv
, colors
, lib
, fetchFromGitHub
, glib
, libxml2
, bc
, gnome3
, gdk-pixbuf
, librsvg
, sassc
, inkscape
, optipng
, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  name = "GTK-Generated";

  src = fetchFromGitHub {
    owner = "themix-project";
    repo = "oomox";
    rev = "1.12.5.3";
    sha256 = "0xz2j6x8zf44bjsq2h1b5105h35z8mbrh8b97i5z5j0zb8k5zhj2";
    fetchSubmodules = true;
  };

  dontBuild = true;

  nativeBuildInputs = [
    glib
    libxml2
    bc
  ];

  buildInputs = [
    gnome3.gnome-themes-extra
    gdk-pixbuf
    librsvg
    sassc
    inkscape
    optipng
  ];

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  installPhase = with colors;
    let
      toRGB = x: lib.removePrefix "#" x;
    in
    ''
      # gtk theme 
        mkdir -p $out/share/themes/${name}
        pushd plugins/theme_oomox/gtk-theme
        patchShebangs .
        echo "  
        BG=${toRGB background}
        FG=${toRGB foreground}
        MENU_BG=${toRGB background}
        MENU_FG=${toRGB background}
        HDR_BG=${toRGB background}
        HDR_FG=${toRGB foreground}
        HDR_BTN_BG=${toRGB background}
        HDR_BTN_FG=${toRGB foreground}
        SEL_BG=${toRGB color9}
        SEL_FG=${toRGB foreground}
        TXT_BG=${toRGB background}
        TXT_FG=${toRGB foreground}
        BTN_BG=${toRGB background}
        BTN_FG=${toRGB foreground}
        HDR_BTN_BG=${toRGB background}
        HDR_BTN_FG=${toRGB foreground}
        WM_BORDER_WIDTH=0
        ROUNDNESS=8
        SPACING=4
        GRADIENT=0
        GTK3_GENERATE_DARK=True
        CARET1_FG=${toRGB foreground}
        CARET2_FG=${toRGB background}
        CARET_SIZE=0.08
        " > /build/source/generated.colors
        HOME=/build/source ./change_color.sh -o ${name} -t $out/share/themes /build/source/generated.colors
        popd
    '';
}   
