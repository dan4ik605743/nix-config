{ pkgs, lib, }:

{
  i3 = {
    enable = true;
    package = pkgs.i3-gaps.overrideAttrs(attr: {
      src = pkgs.fetchurl {
        url = "https://github.com/Airblader/i3/releases/download/4.18.3/i3-4.18.3.tar.bz2";
        sha256 = "1hcakwyz78lgp8mhqv7pw86jlb3m415pfql1q19rkijnhm3fn3ci";
      };
      enableParallelBuilding = false;
      nativeBuildInputs = with pkgs; [ autoreconfHook ] ++ pkgs.i3.nativeBuildInputs;
    });
    extraConfig = ''
      for_window [class="^Wps$"] move to workspace $ws7
      for_window [class="^Wpp$"] move to workspace $ws8
      for_window [class="^osu!$"] move to workspace $ws5
      for_window [class="^Steam$"] move to workspace $ws6
      for_window [class="^Steam$"] floating enable
      assign [class="^qutebrowser$"] → 1
      assign [class="^ViberPC$"] → 4
      assign [class="^discord$"] → 3
      set $ws1 "1""
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"
      '';
    
      config = rec {
        modifier = "Mod4";
        bars = [];
        colors = {
          focused = {
            border = "#4c7899";
            background = "#285577";
            text = "#ffffff";
            indicator = "#854041";
            childBorder = "#854041";
          };
          focusedInactive = {
            border = "#333333";
            background = "#5f676a";
            text = "#ffffff";
            indicator = "#854041";
            childBorder = "#854041";
          };
          unfocused = {
            border = "#333333";
            background = "#222222";
            text = "#888888";
            indicator = "#854041";
            childBorder = "#222222";
          };
          urgent = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
            indicator = "#854041";
            childBorder = "#854041";
          };
          placeholder = {
            border = "#000000";
            background = "#0c0c0c";
            text = "#ffffff";
            indicator = "#854041";
            childBorder = "#854041";
          };
        };
      
        window = {
          titlebar = false;
          border = 2;
        };
      
        gaps = {
          inner = 10;
          smartGaps = false;
        };

        terminal = "${pkgs.termite}/bin/termite";
        menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons";

        keybindings = lib.mkOptionDefault {
        "${modifier}+XF86MonBrightnessUp" = "exec brightnessctl s +10%";
        "${modifier}+XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
        "${modifier}+F2" = "exec flatpak run com.viber.Viber";
        "${modifier}+F11" = "exec screenlock";
        "${modifier}+F10" = "exec ${terminal} -e htop";
        "${modifier}+F3" = "exec prime-run Discord";
        "${modifier}+Print" = "exec cumshot";
        "${modifier}+F1" = "exec prime-run qutebrowser";
        "${modifier}+F12" = "exec pavucontrol";

        "Mod1+F2" = "exec playerctl play-pause";
        "Mod1+F3" = "exec playerctl previous";
        "Mod1+F4" = "exec playerctl next";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioNext" = "exec playerctl next";
        "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
        "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86TouchpadToggle" = "exec synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')";
        "Print" = "exec cumshot1";
      };
      
      startup = [ 
        {
          command = "exec i3-msg workspace 1";
          always = false;
          notification = false;
        }
        {
          command = "${pkgs.feh}/bin/feh --bg-scale /home/dan4ik/.background-image/beach-trees-wallpaper-1360x768.jpg";
          always = false;
          notification = false;
        }
        {
          command = "systemctl --user restart polybar.service";
          always = true;
          notification = false;
        }
        {
          command = ''setxkbmap -layout "us,ru" -option "grp:alt_shift_toggle"'';
          always = true;
          notification = false;
        }
      ];
    };
  };
}
