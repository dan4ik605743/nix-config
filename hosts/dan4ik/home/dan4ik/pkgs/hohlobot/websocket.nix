{ pkgs, fetchurl, python38Full, }:

with pkgs.python3Packages;

buildPythonPackage rec {
  name = "websocket-pip";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/53/e0/2efb92d392e47da31faf26e43f8a5fd2d5130308e4fd8e17d0d92dd05634/simple-websocket-server-0.4.1.tar.gz";
    sha256 = "1413lj7qvnk1kipjhkjmv2s21xzcrlv0jrpw1dvf5nzq5xs9sv8p";
  };
  buildInputs = [ python38Full ];
}
