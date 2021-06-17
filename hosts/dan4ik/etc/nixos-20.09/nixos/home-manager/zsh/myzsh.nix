{ stdenv, fetchFromGitHub, oh-my-zsh, }: 

let
  fast-syntax-highlighting = fetchFromGitHub {
    owner = "zdharma";
    repo = "fast-syntax-highlighting";
    rev = "a62d721affc771de2c78201d868d80668a84c1e1";
    sha256 = "0kwrkxkgsx9cchdrp9jg3p47y6h9w6dgv6zqapzczmx7slgmf4p3";
  };
  zsh-autosuggestions = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "ae315ded4dba10685dbbafbfa2ff3c1aefeb490d";
    sha256 = "0h52p2waggzfshvy1wvhj4hf06fmzd44bv6j18k3l9rcx6aixzn6";
  };
  mytheme = fetchFromGitHub {
    owner = "dan4ik605743";
    repo = "zsh-theme";
    rev = "4c276b63030c5223ce090b152d50c08bd6724671";
    sha256 = "1kbc1jmvkls08kk1glrggbhw753q2yi8ci61nmk5gg4hdwahww0q";
  };
in
  stdenv.mkDerivation {
  name = "myZsh";
  phases = [ "installPhase" ];
  src = oh-my-zsh;
  installPhase = ''
    mkdir $out/share/oh-my-zsh/custom/plugins/{zsh-autosuggestions,fast-syntax-highlighting} $out/share/oh-my-zsh/themes -p
    cp ${fast-syntax-highlighting}/* $out/share/oh-my-zsh/custom/plugins/fast-syntax-highlighting -r
    cp ${zsh-autosuggestions}/* $out/share/oh-my-zsh/custom/plugins/zsh-autosuggestions -r
    cp ${mytheme}/* $out/share/oh-my-zsh/themes -r
    cp $src/* $out -r
  '';
}
