{ pkgs, }:

let
  ## Colors
  ac = "#4DD0E1";
  bg = "#aa1D2731";
  fg = "#f4c1c7";
  trans = "#00000000";
  white = "#FFFFFF";
  black = "#000000";
  red = "#EC7875";
  pink = "#EC407A";
  purple = "#BA68C8";
  blue = "#42A5F5";
  cyan = "#4DD0E1";
  teal = "#00B19F";
  green = "#61C766";
  lime = "#B9C244";
  yellow = "#FDD835";
  amber = "#FBC02D";
  orange = "#E57C46";
  brown = "#AC8476";
  grey = "#8C8C8C";
  indigo = "#6C77BB";
  blue-gray = "#6D8895";
in
  {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      pulseSupport = true;
      alsaSupport = false;
    };
    script = "polybar main &";
    config = {
      "global/wm" = {
        margin-bottom = 0;
        margin-top = 0;
      };
      #====================BARS====================#
      "bar/main" = {
        monitor-strict = false;
        override-redirect = false;
        bottom = false;
        fixed-center = true;

        width = "100%";
        height = 25;
        offset-x = "0%";
        offset-y = "0%";

        background = bg;
        foreground = fg;
        line-size = 2;
        line-color = ac;
        border-bottom-size = 0;
        border-color = ac;
        tray-background = bg;

        radius = 0;
        padding = 2;
        spacing = 0;
        dim-value = "1.0";
        module-margin-left = 1;
        module-margin-right = 1;
        tray-position = "right";
        tray-detached = false;
        tray-maxsize = 16;
        tray-offset-x = 0;
        tray-offset-y = 0;
        tray-padding = 2;
        enable-ipc = true;

        font-0 = "Scientifica:size=8;2";
        font-1 = "waffle:size=12;2";

        modules-left = "i3 sep";
        modules-center = "date";
        modules-right = "sep audio sep";
      };

      "settings" = {
        throttle-output = 5;
        throttle-output-for = 10;
        throttle-input-for = 30;
        screenchange-reload = false;
        compositing-background = "source";
        compositing-foreground = "over";
        compositing-overline = "over";
        comppositing-underline = "over";
        compositing-border = "over";
        pseudo-transparency = false;
      };
      #--------------------MODULES--------------------"
      "module/audio" = {
        type = "internal/pulseaudio";
        use-ui-max = true;
        interval = 5;
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%percentage%%";
        format-muted-prefix = "";
        label-muted = " Muted";
        label-muted-foreground = ac;
        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";
        ramp-volume-3 = "";
        ramp-volume-4 = "";
        ramp-volume-foreground = pink;
      };

      "module/battery" = {
        type = "internal/battery";
        full-at = 98;
        battery = "BAT0";
        adapter = "AC0";
        poll-interval = 2;
        time-format = "%H:%M";
        format-charging = "<animation-charging> <label-charging>";
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-full = "<label-full>";
        format-full-prefix = " ";
        format-full-prefix-foreground = red;
        label-charging = "%percentage%%";
        label-discharging = "%percentage%%";
        label-full = "%percentage%%";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
        ramp-capacity-foreground = amber;
        animation-charging-0 = "";
        animation-charging-1 = "";
        animation-charging-2 = "";
        animation-charging-3 = "";
        animation-charging-4 = "";
        animation-charging-5 = "";
        animation-charging-foreground = green;
        animation-charging-framerate = 750;
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = "0.5";
        format = "<label>";
        format-prefix = "";
        format-prefix-foreground = yellow;
        label = " %percentage%%";
        ramp-load-0 = "";
        ramp-load-1 = "";
        ramp-load-2 = "";
        ramp-load-3 = "";
        ramp-load-4 = "";
      };

      "module/date" = {
        type = "internal/date";
        interval = "1.0";
        date = "It's %A, %d %B %Y";
        time = "at %k:%M:%S";
        format = "<label>";
        format-prefix = " ";
        format-prefix-foreground = red;
        label = "%date% %time%";
      };

      "module/title" = {
        type = "internal/xwindow";
        format = "<label>";
        format-prefix = "";
        format-prefix-foreground = blue;
        label = "%title%";
        label-maxlen = 25;
      };

      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        spacing = "4";
        interval = 10;
        fixed-values = true;
        format-mounted = "<label-mounted>";
        format-mounted-prefix = "";
        format-mounted-prefix-foreground = orange;
        format-unmounted = "<label-unmounted>";
        format-unmounted-prefix = "";
        format-unmounted-prefix-foreground = orange;
        label-mounted = " %free%";
        label-unmounted = "%mountpoint%: not mounted";
      };

      "module/filesystem1" = {
        type = "internal/fs";
        mount-0 = "/home";
        spacing = "4";
        interval = 10;
        fixed-values = true;
        format-mounted = "<label-mounted>";
        format-mounted-prefix = "";
        format-mounted-prefix-foreground = orange;
        format-unmounted = "<label-unmounted>";
        format-unmounted-prefix = "";
        format-unmounted-prefix-foreground = orange;
        label-mounted = " %free%";
        label-unmounted = "%mountpoint%: not mounted";
      };

      "module/sep" = {
        type = "custom/text";
        content = "|";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 3;
        format = "<label>";
        format-prefix = "";
        format-prefix-foreground = blue;
        label = " %mb_used%";
      };

      "module/eth" = {
        type = "internal/network";
        interface = "enp2s0f2";
        interval = "1.0";
        unknown-as-up = true;
        label-connected = "%local_ip%  %downspeed%";
        format-connected-prefix = " ";
      };

      "module/network" = {
        type = "internal/network";
        interface = "wlp3s0";
        interval = "1.0";
        accumulate-stats = true;
        unknown-as-up = true;
        format-connected = "<ramp-signal> <label-connected>";
        format-disconnected = "<label-disconnected>";
        format-disconnected-prefix = " ";
        format-disconnected-prefix-foreground = red;
        label-connected = "%essid%  %downspeed%";
        label-disconnected = "Disconnected";
        ramp-signal-0 = "";
        ramp-signal-1 = "";
        ramp-signal-2 = "";
        ramp-signal-3 = "";
        ramp-signal-4 = "";
        ramp-signal-foreground = purple;
      };

      "module/temperature" = {
        type = "internal/temperature";
        interval = "0.5";
        thermal-zone = 0;
        units = true;
        warn-temperature = 70;
        hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input";
        format = "<ramp> <label>";
        format-warn = "<ramp> <label-warn>";
        label = "%temperature-c%";
        label-warn = "%temperature-c%";
        label-warn-foreground = "#f00";
        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        ramp-3 = "";
        ramp-4 = "";
        ramp-foreground = amber;
      };

      "module/keyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";
        blacklist-1 = "scroll lock";
        format = "<label-layout> <label-indicator>";
        format-prefix = " ";
        format-prefix-foreground = purple;
        label-layout = "%layout%";
        label-indicator-on = "%name%";
        label-indicator-on-foreground = ac;
      };

      "module/i3" = {
        type = "internal/i3";
        internal = 5;
        format = "<label-state> <label-mode>";
        label-mode = "%mode%";
        index-sort = true;
        wrapping-scroll = false;
        label-focused = "%index%";
        label-focused-padding = 2;
        label-focused-foreground = fg;
        label-focused-background = bg;
        label-focused-underline = red;
        label-unfocused = "%index%";
        label-unfocused-padding = 2;
        label-visible = "%index%";
        label-separator = "|";
        label-separator-padding = 1;
        label-urgent = "%index%";
        label-urgent-padding = 2;
      };

      "module/openbox" = {
        type = "internal/xworkspaces";
        pin-workspaces = true;
        enable-click = true;
        enable-scroll = true;
        icon-0 = "1;";
        icon-1 = "2;";
        icon-2 = "3;";
        icon-3 = "4;";
        icon-4 = "5;";
        icon-default = "";
        format = "<label-state>";
        format-padding = 0;
        label-monitor = "%name%";
        label-active = " ";
        label-active-foreground = pink;
        label-active-background = bg;
        label-occupied = "%icon% ";
        label-occupied-foreground = blue;
        label-occupied-background = bg;
        label-urgent = "%icon% ";
        label-urgent-foreground = ac;
        label-urgent-background = bg;
        label-empty = "%icon% ";
        label-empty-foreground = fg;
        label-empty-background = bg;
        label-active-padding = 0;
        label-urgent-padding = 0;
        label-occupied-padding = 0;
        label-empty-padding = 0;
      };
    };
  }
