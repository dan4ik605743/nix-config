{ pkgs, fetchFromGitHub, python38Full, }:

with pkgs.python3Packages;

buildPythonPackage rec {
  name = "catwaresuka";
  src = fetchFromGitHub {
    owner = "Catware-Foundation";
    repo = "Insult-Generator";
    rev = "3217682d09ced9905d90271f142d718e5dce55cd";
    sha256 = "1ysnj5h8fspjxk4r7qymmqgb6gjsf9q85489z4ca0favk2yyvhs4";
  };
  buildInputs = [ python38Full ];
}
