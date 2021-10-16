{ config, pkgs, lib, inputs, ... }:

let
  ## Gtk
  generated = pkgs.callPackage ./pkgs/gtk-generated/default.nix { inherit pywal; };
  ## Pywal
  color = pkgs.callPackage ./pkgs/pywal/default.nix { };
  pywal = builtins.fromJSON (builtins.readFile "${color}/colors-gb.json");
  rofi-theme = builtins.readFile "${color}/colors-rofi-dark-gb.rasi";
  ## Ssh
  sshpub = pkgs.writeText "sshpubkey" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDeOpbBncJZV+x+glutyCsRzsS2igzzCGjlpYjOZQ6aI dan4ik";
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
  ## Cmus
  cmustheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/egel/cmus-gruvbox/master/gruvbox-dark.theme";
    sha256 = "sha256-3BHdmoWiKF/UxP9fGSthrzF9PJeUHQxPwkEXNOkWQqk=";
  };
in
{
  xsession = {
    enable = true;
    initExtra = ''
      xrandr --output eDP-1 --off
      xinput set-prop 12 "Device Accel Constant Deceleration" 2.6
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
          "6" = [{ class = "^Steam$"; }];
          "7" = [{ class = "^Wps$"; }];
          "8" = [{ class = "^Wpp$"; }];
          "9" = [{ class = "^ViberPC$"; }];
          "10" = [{ class = "^TeamSpeak 3$"; }];
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
            type = "internal/date";
            interval = "1.0";
            date = "%A, %d %B %Y";
            time = "%k:%M:%S";
            format = "<label>";
            format-prefix = " ";
            format-prefix-foreground = ct;
            label = "%date% %time%";
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
      '';
      shellAliases = {
        tb = "nc termbin.com 9999";
        xp = "xclip -sel clip";
        ls = "ls -l -F --color=auto";
        nb = "nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}'";
        lsa = "ls -al";
        nup = "doas bash -c 'nix flake update /etc/nixos && nixos-rebuild switch --flake /etc/nixos'";
        nsw = "doas nixos-rebuild switch --flake /etc/nixos";
        ssh = "TERM='xterm-256color' ssh";
        wttr = "curl wttr.in/krasnoyarsk";
        flatout = "steam-run prime-run sh ~/Documents/Games/FlatOut2/start.sh -w ; exit";
      };
    };
    rofi = {
      enable = true;
      package = pkgs.oldstable.rofi;
      font = "Iosevka FT Extended 9";
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
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions;
        [
          ms-dotnettools.csharp
          pkief.material-icon-theme
          vscodevim.vim
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
          [
            {
              name = "gruvbox-themes";
              publisher = "tomphilbin";
              version = "1.0.0";
              sha256 = "sha256-DnwASBp1zvJluDc/yhSB87d0WM8PSbzqAvoICURw03c=";
            }
            {
              name = "fluent-icons";
              publisher = "miguelsolorio";
              version = "0.0.12";
              sha256 = "sha256-lrufKKATmWTxG8vyFSZkxtHOf2KqdJ13dSnibKA003E";
            }
            {
              name = "nix-env-selector";
              publisher = "arrterian";
              version = "1.0.7";
              sha256 = "sha256-DnaIXJ27bcpOrIp1hm7DcrlIzGSjo4RTJ9fD72ukKlc=";
            }
            {
              name = "vscode-solution-explorer";
              publisher = "fernandoescolar";
              version = "0.4.4";
              sha256 = "sha256-uCeqYunAvaI1bEIfy2jHbCsuhjZoGzLwFGKxUzZHht0=";
            }
          ];
      userSettings = {
        update = {
          mode = "none";
          channel = "none";
        };
        telemetry = {
          enableTelemetry = false;
          enableCrashReporter = false;
        };
        workbench = {
          colorTheme = "Gruvbox Dark (Medium)";
          iconTheme = "material-icon-theme";
          productIconTheme = "fluent-icons";
        };
        editor = {
          fontFamily = "JetBrains Mono NL Medium";
          fontLigatures = true;
          fontSize = 14;
        };
        debug.console = {
          fontFamily = "JetBrains Mono NL Medium";
          fontLigatures = true;
          fontSize = 14;
        };
        vim = {
          easymotion = true;
          useSystemClipboard = true;
          useCtrlKeys = true;
          cursorStylePerMode.insert = "line";
          cursorStylePerMode.normal = "line";
          cursorStylePerMode.replace = "line";
          cursorStylePerMode.visual = "line";
          cursorStylePerMode.visualblock = "line";
        };
        terminal.integrated.shell.linux = "bash";
      };
      keybindings =
        [
          {
            key = ''alt+['';
            command = "workbench.action.terminal.kill";
            when = null;
            args = null;
          }
          {
            key = ''alt+]'';
            command = "workbench.action.terminal.new";
            when = "terminalProcessSupported";
            args = null;
          }
          {
            key = ''alt+\'';
            command = "workbench.action.terminal.focus";
            when = null;
            args = null;
          }
          {
            key = ''ctrl+alt+\'';
            command = "workbench.action.terminal.toggleTerminal";
            when = "terminal.active";
            args = null;
          }
        ];
    };
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;
      vimAlias = false;
      viAlias = false;
      extraConfig = import ./config/neovim/neovim.nix;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-closetag
        vim-clap
        lightline-vim
        coc-nvim
        indent-blankline-nvim
        nerdtree
        gruvbox
      ];
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
            i3lock-color -i ~/Documents/pictures/wallpaper/i3lock2.jpg --force-clock -e --indicator \
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
      ".config/nvim/coc-settings.json" = {
        text = import ./config/neovim/coc-settings.nix;
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
      ".config/cmus/gruvbox.theme" = {
        text = builtins.readFile "${cmustheme}";
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
  xresources.extraConfig = import ./config/xresources.nix { inherit pywal; };
}
