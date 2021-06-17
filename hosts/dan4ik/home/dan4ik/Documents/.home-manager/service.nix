{pkgs, ...}:

{
  polybar =
  {
    package = pkgs.polybar.override
    {
      alsaSupport = false;
      githubSupport = false;
      i3GapsSupport = true;
      iwSupport = true;
      mpdSupport = false;
      nlSupport = false;
      pulseSupport = true;
    };
    enable = true;
    script = 
    ''
      polybar main -c .config/polybar/config.ini
    '';
};
};
