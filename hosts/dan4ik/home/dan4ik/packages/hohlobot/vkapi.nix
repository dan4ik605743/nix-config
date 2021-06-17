{fetchurl}:

with import <nixpkgs> {};
with pkgs.python3Packages;

buildPythonPackage rec {
  name = "vkapi";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/25/55/e15721b00dabb5eff7ec87918016ee20a0a73f6c7f5c152643330ae86e84/vk_api-11.9.1.tar.gz";
    sha256 = "0vallqmg383h2b0mginssax5kzvr3c6c90gl9a3qs4chg39yhzc4";
  };
  propagatedBuildInputs = [ websocket_client beautifulsoup4 six certifi idna chardet requests urllib3 ];
  buildInputs = 
  [
    python38Full
    python38Packages.setuptools
  ];
}

