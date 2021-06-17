{ ... }:

{
  enable = true;
  backend = "glx";
  vSync = true;
  refreshRate = 0;
  shadow = false;
  shadowOffsets = [ (-5) (-5) ];
  shadowOpacity = "0.5";
  activeOpacity = "1.0";
  inactiveOpacity = "1.0";
  extraOptions = ''
    fading = true;
    fade-delta = 4;
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    fade-exclude = [ ];
    blur: {
    method = "kernel";
    strength = 13;
    background = false;
    background-frame = false;
    background-fixed = false;
    kernel = "11x11gaussian";
    }
    blur-background-exclude = [
    "class_g = 'slop'",
    ];
    '';
}
