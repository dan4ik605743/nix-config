{ stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  name = "antivirus-popova";
  src = fetchFromGitHub {
    owner = "zigazajc007";
    repo = "Rabbit-Antivirus";
    rev = "b0d57084d1e4f19651c45d4b14d139036d1c6595";
    sha256 = "0p6wsqzlczy8aqi522ndfxrf6dvfkc628iv868mv30nx759gvrsg";
  };
  installPhase = ''
    mkdir -p $out
    g++ rav.cpp -o $out/antivirus
    '';
}
