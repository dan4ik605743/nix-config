{ pkgs, }:

let
  myzsh = pkgs.callPackage ./myzsh.nix {};
in
{
  enable = true;
  initExtra = ''
    export ZSH=${myzsh}/share/oh-my-zsh
    ZSH_THEME="my"
    plugins=(git sudo fast-syntax-highlighting zsh-autosuggestions)
    source $ZSH/oh-my-zsh.sh
    export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 ## osu-lazer
    '';
}
