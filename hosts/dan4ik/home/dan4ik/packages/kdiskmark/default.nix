{ qt5
, fetchFromGitHub
, cmake
, kdeFrameworks
, hicolor-icon-theme
, libaio
}:

qt5.mkDerivation rec {
  pname = "KDiskMark";
  version = "2.1.1";
  src = fetchFromGitHub 
  {
    owner = "JonMagon";
    repo = "KDiskMark";
    rev = version;
    sha256 = "02s7y2hzk3rr374ww728lmf21ygwvx0v238jmraizcgdrbybjhky";
  };
  buildInputs = 
  [ 
    hicolor-icon-theme
    kdeFrameworks.kauth 
    qt5.qtbase
    libaio
  ];
  nativeBuildInputs = 
  [
    kdeFrameworks.extra-cmake-modules
    qt5.qttools
    cmake
  ];
}
