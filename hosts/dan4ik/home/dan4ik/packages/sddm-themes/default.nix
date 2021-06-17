{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation
{
  name = "sddm-git-theme";
  src = fetchFromGitHub {
    owner = "eayus";
    repo = "sddm-theme-clairvoyance";
    rev = "dfc5984ff8f4a0049190da8c6173ba5667904487";
    sha256 = "13z78i6si799k3pdf2cvmplhv7n1wbpwlsp708nl6gmhdsj51i81";
  };
  installPhase = 
  ''
    mkdir $out/share/sddm/themes/sugar -p
    cp -aR $src/* $out/share/sddm/themes/sugar/.
    sed 's/\(autoFocus.*\)=false/\1=true/g' -i $out/share/sddm/themes/sugar/theme.conf 
  '';
}
