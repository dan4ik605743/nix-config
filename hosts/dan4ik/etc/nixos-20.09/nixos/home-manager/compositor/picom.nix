{ pkgs, }:

{
  enable = true;
  package = pkgs.callPackage ./compton.nix {};
  backend = "glx";
  vSync = true;
  refreshRate = 0;
  activeOpacity = "1.0";
  inactiveOpacity = "1.0";
  fade = true;
  fadeDelta = 4;
  fadeSteps = [
    "0.03"
    "0.03"
  ];
  blur = true;
  blurExclude = [
    "class_g = 'slop'"
  ];
  extraOptions = ''
    blur-kern = "3x3box";
    blur-method = "kawase";
    blur-strength = 12; 
    blur-background-frame = true;
    blur-background-fixed = true;
    '';
}
