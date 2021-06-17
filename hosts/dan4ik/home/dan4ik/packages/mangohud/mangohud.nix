{ ... }: with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mangohud";
  src = fetchFromGitHub {
    owner = "flightlessmango";
    repo = "MangoHud";
    rev = "2afc03cc0362a8ea1f3aa5d3ec05907fb96900c2";
    sha256 = "1h0y4lv9jzcqhairjsgdbxvls404z9x3vlyd5crqxsqkklkgzpy1";
  };
  buildInputs = 
  [ 
    meson 
    cmake 
    ninja
    python37Packages.Mako 
    xorg.libX11 
    pkg-config 
    dbus 
    glslang 
    git 
    vulkan-headers 
    vulkan-loader
  ];
}
