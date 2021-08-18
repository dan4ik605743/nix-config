{ config, pkgs, lib, inputs, ... }:

let
  ## Gtk
  generated = pkgs.callPackage ./pkgs/gtk-generated/default.nix { inherit pywal; };
  ## Pywal
  color = pkgs.callPackage ./pkgs/pywal/default.nix { };
  pywal = builtins.fromJSON (builtins.readFile "${color}/colors-gb.json");
  rofi-theme = builtins.readFile "${color}/colors-rofi-dark-gb.rasi";
  ## Rxvt-unicode
  url-select = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/muennich/urxvt-perls/master/deprecated/url-select";
    sha256 = "1pmvjrzjjcihwvzhznm5fjp80bayf342xp0r01zfhhq76jsdbdfz";
  };
  resize-font = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/simmel/urxvt-resize-font/master/resize-font";
    sha256 = "0lhm6dflcrzl8vj4al2yaxry02jpx452kickbm38ba83kylv0jnq";
  };
  tabbedex = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/stepb/urxvt-tabbedex/master/tabbedex";
    sha256 = "sha256-RirynHRM07psha4RqtvZoBasncAW9bt8FRF1H2DdZqk=";
  };
  ## Ssh
  sshpub = pkgs.writeText "sshpubkey" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeOpbBncJZV+x+glutyCsRzsS2igzzCGjlpYjOZQ6aI dan4ik";
in
{
  xsession = {
    enable = true;
    numlock.enable = true;
    initExtra = ''
      xrandr --output eDP-1 --off
      xinput set-prop 13 "Device Accel Constant Deceleration" 2.6
      xinput set-prop 21 "libinput Accel Speed" -0.4
      xset s off && xset dpms 0 0 0
    '';
    windowManager.i3 = with pywal.colors; {
      enable = true;
      package = pkgs.oldstable.i3-gaps;
      config = rec {
        modifier = "Mod4";
        bars = [ ];
        colors = {
          focused = {
            border = "#4c7899";
            background = "#285577";
            text = "#ffffff";
            indicator = "${color4}";
            childBorder = "${color4}";
          };
          focusedInactive = {
            border = "#333333";
            background = "#5f676a";
            text = "#ffffff";
            indicator = "${color4}";
            childBorder = "${color4}";
          };
          unfocused = {
            border = "#333333";
            background = "#222222";
            text = "#888888";
            indicator = "${color4}";
            childBorder = "#222222";
          };
          urgent = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
            indicator = "${color4}";
            childBorder = "${color4}";
          };
          placeholder = {
            border = "#000000";
            background = "#0c0c0c";
            text = "#ffffff";
            indicator = "${color4}";
            childBorder = "${color4}";
          };
        };

        assigns = {
          "1" = [{ class = "^qutebrowser$"; }];
          "5" = [{ class = "^discord$"; }];
          "6" = [{ class = "^Steam$"; }];
          "7" = [{ class = "^Wps$"; }];
          "8" = [{ class = "^Wpp$"; }];
        };
        window = {
          titlebar = false;
          border = 2;
        };
        gaps = {
          inner = 10;
          smartGaps = false;
        };

        defaultWorkspace = "workspace number 1";

        terminal = "urxvtc";
        menu = "rofi -show drun -show-icons";

        keybindings = lib.mkOptionDefault {
          "${modifier}+XF86MonBrightnessUp" = "exec brightnessctl s +10%";
          "${modifier}+XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
          "${modifier}+Print" = "exec maim -u | xclip -selection clipboard -t image/png";
          "${modifier}+F12" = "exec pavucontrol";
          "${modifier}+F11" = "exec screenlock";
          "${modifier}+F10" = "exec urxvtc -e htop";
          "${modifier}+F1" = "exec qutebrowser";

          "Mod1+F2" = "exec playerctl play-pause";
          "Mod1+F3" = "exec playerctl previous";
          "Mod1+F4" = "exec playerctl next";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
          "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle";
          "XF86TouchpadToggle" = "exec synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')";
          "Print" = "exec maim -su | xclip -selection clipboard -t image/png";
        };
        startup = [
          {
            command = "feh --bg-fill /etc/nixos/system/pkgs/pywal/current";
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
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      package = generated;
      name = "generated";
    };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "elementary";
      gtk-cursor-theme-size = 0;
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="elementary"
      gtk-cursor-theme-size=0
    '';
  };
  services = with pywal.special; with pywal.colors; {
    polybar =
      let
        bg = "${background}";
        fg = "${foreground}";
        ct = "${color4}";
      in
      {
        enable = true;
        script = "polybar main &";
        package = pkgs.polybar.override {
          i3GapsSupport = true;
          pulseSupport = true;
          alsaSupport = false;
          githubSupport = false;
          iwSupport = false;
          mpdSupport = false;
          nlSupport = false;
        };
        config = {
          "global/wm" = {
            margin-bottom = 0;
            margin-top = 0;
          };
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
            line-color = ct;
            border-bottom-size = 0;
            border-color = ct;
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

            font-0 = "DejaVu Sans:size=8;2";
            font-1 = "waffle:size=12;2";

            modules-left = "i3 sep";
            modules-center = "date";
            modules-right = "sep volume sep";
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
          "module/volume" = {
            type = "internal/pulseaudio";
            format-volume = "<ramp-volume> <label-volume>";
            label-volume = "%percentage%%";
            format-muted-prefix = "";
            label-muted = " Muted";
            label-muted-foreground = ct;
            use-ui-max = false;
            ramp-volume-0 = "";
            ramp-volume-1 = "";
            ramp-volume-2 = "";
            ramp-volume-3 = "";
            ramp-volume-4 = "";
            ramp-volume-foreground = ct;
          };
          "module/date" = {
            type = "custom/script";
            interval = "1.0";
            exec = ''LANG=ru_RU.UTF-8 ${pkgs.coreutils}/bin/date +%A,\ %d\ %B\ %Y\ %k:%M:%S'';
            format = "<label>";
            format-prefix = " ";
            format-prefix-foreground = ct;
            label = "%output%";
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
            label-focused-underline = ct;
            label-unfocused = "%index%";
            label-unfocused-padding = 2;
            label-visible = "%index%";
            label-separator = "|";
            label-separator-padding = 1;
            label-urgent = "%index%";
            label-urgent-padding = 2;
          };
          "module/sep" = {
            type = "custom/text";
            content = "|";
          };
        };
      };
    picom = {
      enable = true;
      package = pkgs.nur.repos.dan4ik605743.compton;
      backend = "glx";
      vSync = true;
      refreshRate = 60;
      activeOpacity = "1.0";
      inactiveOpacity = "1.0";
    };
  };
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        PS1="\[\033[38;5;245m\]λ\[$(tput sgr0)\] \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;244m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]"
        export PATH="$HOME/.emacs.d/bin:$PATH"
      '';
      shellAliases = {
        tb = "nc termbin.com 9999";
        ew = "emacs -nw";
        xp = "xclip -sel clip";
        ls = "ls -l -F --color=auto";
        nb = "nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'";
        lsa = "ls -al";
        dew = "doas emacs -nw";
        eww = "emacsclient -c -a emacs";
        nup = "doas bash -c 'nix flake update /etc/nixos && nixos-rebuild switch --flake /etc/nixos'";
        nsw = "doas nixos-rebuild switch --flake /etc/nixos";
      };
    };
    rofi = {
      enable = true;
      font = "Hack 9";
      terminal = "urxvtc";
      theme = builtins.toString (pkgs.writeText "rofi-theme" "${rofi-theme}");
    };
    qutebrowser = {
      enable = true;
      searchEngines = { DEFAULT = "https://google.com/search?q={}"; };
      settings.url.start_pages = [ "https://dan4ik605743.github.io" ];
      extraConfig = import ./config/qutebrowser.nix;
    };
    git = {
      enable = true;
      userEmail = "6057430gu@gmail.com";
      userName = "dan4ik";
    };
    htop = {
      enable = true;
      settings = {
        vim_mode = true;
      };
    };
    nix-index = {
      enable = true;
      enableFishIntegration = false;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };
    command-not-found.enable = true;
    firefox.enable = true;
  };
  home = {
    sessionVariables = {
      EDITOR = "emacsclient -c -a emacs";
      BROWSER = "qutebrowser";
      TERMINAL = "urxvtc";
      XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_PICTURES_DIR = "${config.home.homeDirectory}/Downloads";
      XDG_RUNTIME_DIR = "/run/user/1000";
    };
    keyboard = {
      options = [ "grp:alt_shift_toggle" ];
      layout = "us,ru";
    };
    packages = with pkgs;
      let
        myscreenlock = pkgs.writeShellScriptBin "screenlock"
          ''
            white=ffffffff
            transparency=00000000
            black=000000ff
            font="roboto"
            tx=120
            ty=690

            setxkbmap us
            i3lock-color -i ~/Documents/wallpaper/i3lock2.jpg --force-clock -e --indicator \
            --timecolor=$white --datecolor=$white --insidevercolor=$transparency --insidewrongcolor=$transparency \
            --insidecolor=$transparency --ringvercolor=$white --ringwrongcolor=$white --ringcolor=$white \
            --linecolor=$transparency --keyhlcolor=$black --bshlcolor=$black \
            --timepos="$tx:$ty" --datepos="$tx:(($ty+20))" --indpos="(($tx + 120)):(($ty -4))" \
            --timesize=45 --datesize=16 --radius 20 --ring-width 3.5 \
            --time-font=$font --date-font=$font \
            --timestr="%H:%M" --datestr="%d %A %B" --veriftext="" --wrongtext="" --noinputtext="" --locktext="" \
            --lockfailedtext=""
            setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle'
          '';
      in
      [
        myscreenlock
      ];
    file = {
      ".config/bpytop/bpytop.conf" = {
        text = import ./config/bpytop.nix;
      };
      ".config/nixpkgs/config.nix" = {
        text = import ./config/nixpkgs.nix;
      };
      ".doom.d/config.el" = {
        text = import ./config/doom/config.nix;
      };
      ".doom.d/init.el" = {
        text = import ./config/doom/init.nix;
      };
      ".doom.d/packages.el" = {
        text = import ./config/doom/packages.nix;
      };
      ".urxvt/ext/url-select" = {
        text = builtins.readFile "${url-select}";
      };
      ".urxvt/ext/resize-font" = {
        text = builtins.readFile "${resize-font}";
      };
      ".urxvt/ext/tabbedex" = {
        text = builtins.readFile "${tabbedex}";
      };
      ".ssh/id_ed5519.pub" = {
        text = builtins.readFile "${sshpub}";
      };
    };
    username = "dan4ik";
    homeDirectory = "/home/${config.home.username}";
  };
  xresources.extraConfig = import ./config/xresources.nix { inherit pywal; };
}
