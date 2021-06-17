{ python3
, lib
, fetchFromGitHub
, fetchpatch
, wirelesstools
, aircrack-ng
, wireshark-cli
, reaverwps-t6x
, pixiewps
, cowpatty
, hcxtools
, hcxdumptool
, pyrit
, bully
, which 
}:

python3.pkgs.buildPythonApplication rec 
{
  version = "2.5.7";
  pname = "wifite2";

  src = fetchFromGitHub 
  {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    sha256 = "0p7n395lby4yhpsn4r3sdxgyqlkflbz8n73akjyckqqi48wr97vl";
  };

  patches = 
  [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/${version}-1/debian/patches/Disable-aircrack-failing-test.patch";
      sha256 = "04qql8w27c1lqk59ghkr1n6r08jwdrb1dcam5k88szkk2bxv8yx1";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/${version}-1/debian/patches/Disable-two-failing-tests.patch";
      sha256 = "1sixcqz1kbkhxf38yq55pwycm54adjx22bq46dfnl44mg69nx356";
    })
  ];

  propagatedBuildInputs = 
  [
    aircrack-ng
    wireshark-cli
    reaverwps-t6x
    pixiewps
    cowpatty
    hcxtools
    hcxdumptool
    wirelesstools
    pyrit
    bully
    which
  ];

  postFixup = 
  let
    sitePackagesDir = "$out/lib/python3.${lib.versions.minor python3.version}/site-packages";
  in ''
    mv ${sitePackagesDir}/wifite/__main__.py ${sitePackagesDir}/wifite/wifite.py
  '';

  checkInputs = propagatedBuildInputs;
  checkPhase = "python -m unittest discover tests -v";
}
