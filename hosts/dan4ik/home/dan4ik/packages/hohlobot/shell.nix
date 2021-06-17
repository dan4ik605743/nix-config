{ pkgs ? import <nixpkgs> {} }:

let
  vkapi = pkgs.python38Packages.buildPythonPackage rec {
    pname = "vk_api";
    version = "11.9.3";
    propagatedBuildInputs = with pkgs.python38Packages; [ websocket_client beautifulsoup4 six certifi idna chardet requests urllib3 ];
    src = pkgs.python38Packages.fetchPypi {
      inherit pname version;
      sha256 = "0c4bsg1wradvgin3j04vb65jr5ql3w0qxd6cijkmffihc9ssnf00";
    };
  };
  websocket = pkgs.python38Packages.buildPythonPackage rec {
    pname = "simple-websocket-server";
    version = "0.4.1";
    src = pkgs.python38Packages.fetchPypi {
      inherit pname version;
      sha256 = "1413lj7qvnk1kipjhkjmv2s21xzcrlv0jrpw1dvf5nzq5xs9sv8p";
    };
  };
  catware = pkgs.python38Packages.buildPythonPackage rec {
    name = "catwaresuka";
    src = pkgs.fetchFromGitHub {
      owner = "Catware-Foundation";
      repo = "Insult-Generator";
      rev = "3217682d09ced9905d90271f142d718e5dce55cd";
      sha256 = "1ysnj5h8fspjxk4r7qymmqgb6gjsf9q85489z4ca0favk2yyvhs4";
    };
  };
  customPython = pkgs.python38.buildEnv.override {
    extraLibs = [ vkapi websocket catware pkgs.python38Packages.ipython pkgs.python38Packages.pygobject3 ];
  };
in
  pkgs.mkShell {
    shellHook = "
    git clone https://gitlab.com/platoff/hohlobot 
    cd hohlobot
    git pull
    ./main.py
    ";
    buildInputs = [ 
      customPython pkgs.python38Full pkgs.python38Packages.setuptools 
    ];
}
