{ config, pkgs, lib, ... }:

let
  # Theme
  colors = import ../../config/colors.nix;
  rofi-theme = import ./config/rofi.nix { inherit colors; };
  gtk-theme = pkgs.callPackage ../../derivations/gtk-generated/default.nix { inherit colors; };

  cmus-theme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/xero/dotfiles/master/cmus/.cmus/nord.theme";
    sha256 = "sha256-ZqhaNSJwZJOycmOfxIdzpI4gHx/ye57INJnZ7e9cV/k=";
  };

  # Rxvt-unicode
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

  # Vim-plug
  vim-plug = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
    sha256 = "sha256-CHWfgQuZIESTK6WRiWTlDTstEnUNp1oQ5Mj2CHvASVM=";
  };

  # Cmus
  cmus-rc = pkgs.writeText "rc" ''
    add ~/nfs/music
    set start_view=1
    colorscheme cmus
  '';
in
{
  xsession = {
    enable = true;

    initExtra = ''
      xrandr --output LVDS-1 --off
      xinput set-prop 11 "Device Accel Constant Deceleration" 2.6
      xset s off && xset dpms 0 0 0
    '';

    windowManager.i3 = with colors; {
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
          "7" = [{ class = "^Wps$"; }];
          "8" = [{ class = "^Wpp$"; }];
          "9" = [{ class = "^ViberPC$"; }];
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
          "${modifier}+Print" = "exec maim -u | xclip -selection clipboard -t image/png";
          "${modifier}+F12" = "exec pavucontrol";
          "${modifier}+F11" = "exec screenlock";
          "${modifier}+F10" = "exec urxvtc -e htop";
          "${modifier}+F1" = "exec qutebrowser";

          "Mod1+F2" = "exec playerctl play-pause";
          "Mod1+F3" = "exec playerctl previous";
          "Mod1+F4" = "exec playerctl next";
          "Mod1+space" = "move scratchpad";
          "Mod1+Tab" = "scratchpad show, resize set 1366 750, move position center";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute 0 toggle";
          "XF86TouchpadToggle" = "exec synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')";
          "Print" = "exec maim -su | xclip -selection clipboard -t image/png";
        };

        startup = [
          {
            command = "feh --bg-fill /etc/nixos/assets/wallpapers/current.png";
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

    font = {
      name = "JetBrains Mono Bold";
      size = 9;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      package = gtk-theme;
      name = "GTK-Generated";
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

  services = {
    polybar = with colors; {
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
          fixed-center = true;
          width = "100%";
          height = 27;
          padding = 2;

          enable-ipc = true;
          background = background;
          foreground = foreground;
          line-color = color4;
          line-size = 3;

          tray-detached = false;
          tray-position = "right";
          tray-maxsize = 16;
          tray-padding = 2;
          tray-background = background;

          font-0 = "JetBrainsMono:size=9;2";
          font-1 = "Font Awesome 5 Free:size=9;2";
          font-2 = "Font Awesome 5 Free Solid:size=9;2";
          font-3 = "Font Awesome 5 Brands:size=9;2";

          modules-left = "workspaces";
          modules-center = "date";
          modules-right = "volume";
        };

        "settings" = {
          screenchange-reload = false;
          pseudo-transparency = false;
          compositing-background = "source";
          compositing-foreground = "over";
          compositing-overline = "over";
          comppositing-underline = "over";
          compositing-border = "over";
        };

        "module/volume" = {
          type = "internal/pulseaudio";
          handle-events = false;

          ramp-volume-0 = "";
          ramp-volume-1 = "";
          ramp-volume-2 = "";

          ramp-volume-foreground = color4;
          ramp-volume-font = 6;
          ramp-volume-padding-right = 1;

          label-volume = "%percentage%%";
          label-volume-foreground = foreground;
          label-muted = "%percentage%%";
          label-muted-foreground = color4;

          format-volume = "<ramp-volume><label-volume>";
          format-volume-padding = 1;
          format-volume-margin = 0;
          format-volume-background = background-alt;
          format-volume-overline = background;
          format-volume-underline = background;

          format-muted-prefix = "";
          format-muted-prefix-padding-right = 1;
          format-muted-prefix-foreground = color4;
          format-muted-padding = 1;
          format-muted-margin = 0;
          format-muted-foreground = color4;
          format-muted-background = background-alt;
          format-muted-overline = background;
          format-muted-underline = background;
        };

        "module/date" = {
          type = "internal/date";
          label = "%date% %time%";
          date = "%a %d-%m-%Y";
          time = "%H:%M";
          interval = 5;

          format-prefix = "";
          format-prefix-font = 6;
          format-prefix-padding-right = 1;
          format-prefix-padding-left = 0;

          format-padding = 1;
          format-margin = 1;
          format-overline = background;
          format-underline = background;
          format-prefix-foreground = color4;
          format-background = background-alt;
        };

        "module/workspaces" = {
          type = "internal/xworkspaces";
          pin-workspaces = true;
          enable-scroll = false;
          enable-click = false;

          icon-0 = "1;";
          icon-1 = "2;";
          icon-2 = "3;";
          icon-3 = "4;";
          icon-4 = "5;";
          icon-5 = "7;";
          icon-6 = "8;";
          icon-7 = "9;";
          icon-default = "";

          format = "<label-state>";
          format-overline = background;
          format-underline = background;

          label-monitor = "%name%";
          label-active = "%icon%";
          label-active-foreground = foreground;
          label-active-background = color4;

          label-occupied = "%icon%";
          label-occupied-foreground = foreground;
          label-occupied-background = background-alt;

          label-urgent = "%icon%";
          label-urgent-foreground = foreground;
          label-urgent-background = color4;

          label-empty = "%icon%";
          label-empty-foreground = foreground;
          label-empty-background = background-alt;

          label-active-padding = 1;
          label-urgent-padding = 1;
          label-occupied-padding = 1;
          label-empty-padding = 1;
        };
      };
    };

    picom = {
      enable = true;
      vSync = true;
      refreshRate = 60;
      backend = "glx";
      activeOpacity = "1.0";
      inactiveOpacity = "1.0";
      package = pkgs.nur.repos.dan4ik605743.compton;
    };

    dunst = with colors; {
      enable = true;

      iconTheme = {
        name = "Papirus-Dark";
        size = "32x32";
        package = pkgs.papirus-icon-theme;
      };

      settings = {
        global = {
          show_indicators = false;
          markup = "full";
          alignment = "center";
          word_wrap = "yes";
          format = "<b>%s</b>\n%b";
          font = "JetBrainsMono 9.2";
          separator_color = "auto";
          icon_position = "left";
          geometry = "330x5-8+25";
          frame_color = color4;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          max_icon_size = 50;
        };

        urgency_low = {
          foreground = foreground;
          background = background;
          frame_color = color4;
          timeout = 2;
        };

        urgency_normal = {
          foreground = foreground;
          background = background;
          frame_color = color4;
          timeout = 4;
        };

        urgency_critical = {
          foreground = foreground;
          background = background;
          frame_color = color4;
        };
      };
    };
  };

  programs = {
    bash = {
      enable = true;

      bashrcExtra = ''
        PS1="\[\033[38;5;245m\]λ\[$(tput sgr0)\] \[$(tput sgr0)\]\[$(tput bold)\]\[\033[38;5;244m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]"
      '';

      shellAliases = {
        tb = "nc termbin.com 9999";
        xp = "xclip -sel clip";
        ls = "ls -l -F --color=auto";
        df = "df -hT";
        nb = "nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'";
        db = "dotnet build";
        dr = "dotnet run";
        lsa = "ls -al";
        nup = "doas bash -c 'nix flake update /etc/nixos && nixos-rebuild switch --flake /etc/nixos'";
        nsw = "doas nixos-rebuild switch --flake /etc/nixos#ggwp";
        ssh = "TERM='xterm-256color' ssh";
        wttr = "curl wttr.in/krasnoyarsk";
        repl = "nix repl /etc/nixos/repl.nix";
        inxi = "inxi -F";
        develop = "nix develop /etc/nixos";
      };
    };

    rofi = {
      enable = true;
      package = pkgs.oldstable.rofi;
      font = "Iosevka FT Extended 9";
      terminal = "urxvtc";
      theme = builtins.toString (pkgs.writeText "rofi-theme" "${rofi-theme}");

      extraConfig = {
        display-drun = "λ";
      };
    };

    qutebrowser = {
      enable = true;
      searchEngines = { DEFAULT = "https://google.com/search?q={}"; };
      settings.url.start_pages = [ "https://dan4ik605743.github.io" ];

      extraConfig = ''
        c.auto_save.session = True
        c.fonts.default_family = "Iosevka FT Extended"
        c.fonts.default_size = "13px"
        c.colors.webpage.darkmode.enabled = True
        c.colors.webpage.darkmode.policy.images = "never"
        config.set('content.notifications.enabled', True, 'vk.com/*')
        config.set('content.media.audio_capture', True, '*')
        config.source('qutebrowser-theme.py')
      '';
    };

    git = {
      enable = true;
      userName = "dan4ik";
      userEmail = "6057430gu@gmail.com";

      aliases = {
        a = "add";
        b = "branch";
        c = "commit -m";
        p = "push -f";
        r = "rebase -i";
        s = "status";
        cc = "checkout";
        pp = "pull";
        rr = "restore";
      };

      extraConfig = {
        web.browser = "${config.home.sessionVariables.BROWSER}";
        core.editor = "${config.home.sessionVariables.EDITOR}";
      };
    };
    htop = {
      enable = true;

      settings = {
        vim_mode = true;
        tree_view = true;
        hide_kernel_threads = true;
        hide_userland_threads = true;
      };
    };

    nix-index = {
      enable = true;
      enableFishIntegration = false;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };

    command-not-found.enable = true;
  };
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "qutebrowser";
      TERMINAL = "urxvtc";
    };

    keyboard = {
      options = [ "grp:alt_shift_toggle" ];
      layout = "us,ru";
    };

    packages = with colors;
      let
        myscreenlock = pkgs.writeShellScriptBin "screenlock"
          ''
            text=${color7}
            transparency=00000000
            color=${color4}
            font="JetBrainsMono"
            tx=120
            ty=690

            setxkbmap us
            i3lock-color -i /etc/nixos/assets/wallpapers/i3lock.png --force-clock -e --indicator \
            --timecolor=$text --datecolor=$text --insidevercolor=$transparency --insidewrongcolor=$transparency \
            --insidecolor=$transparency --ringvercolor=$text --ringwrongcolor=$text --ringcolor=$text \
            --linecolor=$transparency --keyhlcolor=$color --bshlcolor=$color \
            --timepos="$tx:$ty" --datepos="$tx:(($ty+20))" --indpos="(($tx + 120)):(($ty -4))" \
            --timesize=32 --datesize=14 --radius 20 --ring-width 3.5 \
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
      ".config/qutebrowser/qutebrowser-theme.py" = {
        text = import ./config/qutebrowser.nix;
      };

      ".config/bpytop/bpytop.conf" = {
        text = import ./config/bpytop.nix;
      };

      ".config/nixpkgs/config.nix" = {
        text = import ./config/nixpkgs.nix;
      };

      ".config/nvim/coc-settings.json" = {
        text = import ./config/neovim/coc-settings.nix;
      };

      ".config/nvim/init.vim" = {
        text = import ./config/neovim/neovim.nix { inherit pkgs; };
      };

      ".config/cmus/cmus.theme" = {
        text = builtins.readFile "${cmus-theme}";
      };

      ".config/cmus/rc" = {
        text = builtins.readFile "${cmus-rc}";
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

      ".local/share/nvim/site/autoload/plug.vim" = {
        text = builtins.readFile "${vim-plug}";
      };
    };

    username = "dan4ik";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "21.05";
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      download = "${config.home.homeDirectory}/Downloads";
      desktop = "${config.home.homeDirectory}";
      documents = "${config.home.homeDirectory}/Documents";
      music = "${config.home.homeDirectory}/Documents/music";
      pictures = "${config.home.homeDirectory}/Documents/pictures";
      videos = "${config.home.homeDirectory}/Documents/videos";
    };
  };

  xresources.extraConfig = import ./config/xresources.nix { inherit colors; };
}
