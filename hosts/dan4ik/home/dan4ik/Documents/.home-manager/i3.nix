{ config, lib, pkgs, ... }:

let 
  modifer = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      bars = [];
      colors = 
      {
        focused = 
        {
          border = #4c7899
          background = #285577
          text = #ffffff
          indicator = #1E2BD3
          childBorder = #1E2BD3
        };
        focusedInactive =
        {
          border = #333333
          background = #5f676a
          text = #ffffff
          indicator = #1E2BD3
          childBorder = #1E2BD3
        };
        unfocused =
        {
          border = #333333
          background = #222222
          text = #888888
          indicator = #1E2BD3
          childBorder = #222222
        };
        urgent = 
        {
          border = #2f343a
          background = #900000
          text = #ffffff
          indicator = #1E2BD3
          childBorder = #1E2BD3
        };
        placeholder =
        {
          border = #000000
          background = #0c0c0c
          text = #ffffff
          indicator = #1E2BD3
          childBorder = #1E2BD3
        };
      };

      window =
      {
        titlebar = false;
        border = 1;

      gaps = 
      {
        inner = 13;
        smartGaps = true;
        smartBorders = "off";
      };

       terminal = "${pkgs.termite}/bin/termite";
       menu = "${pkgs.rofi}/bin/rofi -show combi -show-icons";

       keybindings =
      {
        "${modifier}+Down" = "focus down";
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+shift+0" = "move container to workspace number 10";
        "${modifier}+shift+1" = "move container to workspace number 1";
        "${modifier}+shift+2" = "move container to workspace number 2";
        "${modifier}+shift+3" = "move container to workspace number 3";
        "${modifier}+shift+4" = "move container to workspace number 4";
        "${modifier}+shift+5" = "move container to workspace number 5";
        "${modifier}+shift+6" = "move container to workspace number 6";
        "${modifier}+shift+7" = "move container to workspace number 7";
        "${modifier}+shift+8" = "move container to workspace number 8";
        "${modifier}+shift+9" = "move container to workspace number 9";

        "${modifier}+Shift+r" = "restart";
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec ${menu}";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+h" = "split h";
        "${modifier}+minus" = "scratchpad show";
        "${modifier}+r" = "mode resize";
        "${modifier}+s" = "layout stacking";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+v" = "split v";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${modifer}+XF86MonBrightnessUp" = "exec brightnessctl s +10%";
        "${modifer}+XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
        "${modifer}+F2" = "exec flatpak run com.viber.Viber";
        "${modifer}+XF86TouchpadToggle" = "exec synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')";
        "${modifer}+F11" = "exec i3lock -i wallpaper/i3lock1.png";
        "${modifer}+F10" = "exec termite -e htop";
        "${modifer}+F3" = "exec prime-run Discord";
        "Print" = "exec  maim -s ~/.cache/screen.png && cat ~/.cache/screen.png| xclip -selection clipboard -t image/png";
        "${modifer}+Print" = "exec maim ~/.cache/screen.png && cat ~/.cache/screen.png| xclip -selection clipboard -t image/png";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";
        "Mod1+F2" = "exec playerctl play-pause";
        "Mod1+F4" = "exec playerctl next";
        "Mod1+F3" = "exec playerctl previous";
        "${modifer}+F1" = "exec prime-run chromium";
        "${modifer}+F12" = "exec pavucontrol";
        
      };
#      startup = 
#        {
#          command = "systemctl --user restart polybar.service";
#          always = true;
#          notification = false;
#        }
};
};
};
