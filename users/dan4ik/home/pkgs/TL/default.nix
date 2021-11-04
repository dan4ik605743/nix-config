with import <nixpkgs> { };

(buildFHSUserEnv
  {
    name = "TLauncher";

    targetPkgs = pkgs: (with pkgs;
      [
        fontconfig
        cairo
        pango
        gtk2-x11
        gdk_pixbuf
        freetype
        atk
        libxml2
        libxslt
        openjfx11
        glib-networking
        glib
        ffmpeg
        libGL
        jdk
        alsaLib
        flite
        jre
        alsaOss
      ] ++ (with xorg;

      [
        libX11
        libXext
        libXcursor
        libXrandr
        libXrender
        libXtst
        libXi
        libXxf86vm
      ]));

    runScript = "bash -c 'prime-run java -jar ~/Documents/pkgs/TL/TLauncher.jar'";
  }).env
