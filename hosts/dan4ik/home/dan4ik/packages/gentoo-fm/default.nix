{ stdenv
, fetchurl
, gtk3
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "gentoo";
  version = "0.20.7";
  src = fetchurl {
    url = "http://downloads.sourceforge.net/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1amiibrarywi92r3v469jqjl7pfqbc897868812pwbwsa0ws2l4s";
  };
  nativeBuildInputs = [ gtk3 pkg-config ];
}
