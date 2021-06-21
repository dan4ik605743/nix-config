{ config, pkgs, lib, inputs, ... }:

let
  ## Zsh
  myzsh = pkgs.nur.repos.dan4ik605743.myzsh;
  ## Gtk
  generated = pkgs.callPackage ./pkgs/gtk-generated/default.nix { inherit pywal; };
  ## Pywal
  color = pkgs.callPackage ./pkgs/pywal/default.nix { };
  pywal = builtins.fromJSON (builtins.readFile "${color}/colors.json");
  backrgb = builtins.match ".*Colour2\"=\"([0-9]+),([0-9]+),([0-9]+)\".*$" (builtins.readFile "${color}/colors-putty.reg");
  rofi-theme = builtins.readFile "${color}/colors-rofi-dark.rasi";
  polybar-colors = builtins.fromJSON (builtins.readFile "${color}/polybar.json");
in
{
  xsession = {
    enable = true;
    numlock.enable = true;
    initExtra = ''
      xrandr --output eDP-1 --off
      xinput set-prop 15 "Device Accel Constant Deceleration" 2.6
      xinput set-prop 21 "libinput Accel Speed" -0.4
      xset s off && xset dpms 0 0 0
    '';
    windowManager.i3 = with pywal.colors; {
      enable = true;
      package = pkgs.stable.i3-gaps.overrideAttrs (attr: {
        src = pkgs.fetchurl {
          url = "https://github.com/Airblader/i3/releases/download/4.18.3/i3-4.18.3.tar.bz2";
          sha256 = "1hcakwyz78lgp8mhqv7pw86jlb3m415pfql1q19rkijnhm3fn3ci";
        };
        enableParallelBuilding = false;
        nativeBuildInputs = with pkgs; [ autoreconfHook ] ++ pkgs.stable.i3.nativeBuildInputs;
      });
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
          "3" = [{ class = "^discord$"; }];
          "5" = [{ class = "^osu!$"; }];
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
        terminal = "${pkgs.termite}/bin/termite";
        menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons";

        keybindings = lib.mkOptionDefault {
          "${modifier}+XF86MonBrightnessUp" = "exec brightnessctl s +10%";
          "${modifier}+XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
          "${modifier}+Print" = "exec maim -u | xclip -selection clipboard -t image/png";
          "${modifier}+F11" = "exec screenlock";
          "${modifier}+F10" = "exec ${terminal} -e htop";
          "${modifier}+F12" = "exec ${terminal} -e alsamixer";
          "${modifier}+F1" = "exec qutebrowser";

          "Mod1+F2" = "exec playerctl play-pause";
          "Mod1+F3" = "exec playerctl previous";
          "Mod1+F4" = "exec playerctl next";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioNext" = "exec playerctl next";
          "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
          "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
          "XF86AudioRaiseVolume" = "exec --no-startup-id amixer sset 'Master' 5%+";
          "XF86AudioLowerVolume" = "exec --no-startup-id amixer sset 'Master' 5%-";
          "XF86AudioMute" = "exec --no-startup-id amixer sset 'Master' toggle";
          "XF86TouchpadToggle" = "exec synclient TouchpadOff=$(synclient -l | grep -c 'TouchpadOff.*=.*0')";
          "Print" = "exec maim -su | xclip -selection clipboard -t image/png";
        };
        startup = [
          {
            command = "${pkgs.feh}/bin/feh --bg-scale /etc/nixos/system/pkgs/pywal/current";
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
    gtk3 = {
      extraCss = ''
        VteTerminal, vte-terminal {
        padding: 15px;
        }
      '';
      extraConfig = {
        gtk-cursor-theme-name = "LyraF-cursors";
        gtk-cursor-theme-size = 0;
      };
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-name="LyraF-cursors"
      gtk-cursor-theme-size=0
    '';
  };
  services = with pywal.special; with pywal.colors; with polybar-colors.special; {
    polybar =
      let
        ac = "#4DD0E1";
        bg = "${background1}";
        fg = "${foreground}";
        custom = "${color4}";
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
        script = "polybar main &";
        package = pkgs.polybar.override {
          i3GapsSupport = true;
          alsaSupport = true;
          pulseSupport = false;
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
            modules-right = "sep alsa sep";
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
          "module/alsa" = {
            type = "internal/alsa";
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
            label-focused-underline = custom;
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
    };
  };
  programs = {
    zsh = {
      enable = true;
      initExtra = ''
        export ZSH=${myzsh}/share/oh-my-zsh
        ZSH_THEME="my"
        plugins=(git sudo fast-syntax-highlighting zsh-autosuggestions)
        source $ZSH/oh-my-zsh.sh
      '';
      shellGlobalAliases = {
        tb = "nc termbin.com 9999";
      };
    };
    bash = {
      enable = true;
      bashrcExtra = ''
        PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]\[$(tput sgr0)\]: \[$(tput sgr0)\]"
      '';
      shellAliases = {
        tb = "nc termbin.com 9999";
      };
    };
    rofi = {
      enable = true;
      font = "Hack 10";
      terminal = "${pkgs.termite}/bin/termite";
      theme = builtins.toString (pkgs.writeText "rofi-theme" "${rofi-theme}");
    };
    qutebrowser = {
      enable = true;
      searchEngines = { DEFAULT = "https://google.com/search?q={}"; };
      settings = {
        url.start_pages = [ "https://vk.com" ];
      };
      extraConfig = ''
        c.auto_save.session = True
        c.fonts.default_family = "JetBrainsMono Nerd Font Mono Bold"
        c.fonts.default_size = "14px"
        c.colors.webpage.darkmode.enabled = True
        c.colors.webpage.darkmode.policy.images = "never"
        config.source('/etc/nixos/system/pkgs/config/qutebrowser-theme.nix')
      '';
    };
    vscode = {
      enable = false;
      extensions = with pkgs.vscode-extensions;
        [
          ms-vscode.cpptools
          bbenoist.Nix
          pkief.material-icon-theme
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
          [
            {
              name = "nix-env-selector";
              publisher = "arrterian";
              version = "0.1.2";
              sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
            }
            {
              name = "theme-monokai-pro-vscode";
              publisher = "monokai";
              version = "1.1.19";
              sha256 = "0skzydg68bkwwwfnn2cwybpmv82wmfkbv66f54vl51a0hifv3845";
            }
          ];
      userSettings = {
        "update.channel" = "none";
        "telemetry.enableTelemetry" = "false";
        "telemetry.enableCrashReporter" = "false";
        "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.colorTheme" = "Monokai Pro (Filter Machine)";
        "editor.fontFamily" = "Iosevka";
        "editor.fontLigatures" = "true";
        "editor.fontSize" = 16;
      };
    };
    termite = with pywal.special; {
      enable = true;
      allowBold = true;
      font = "JetBrainsMono Nerd Font Mono Bold 9";
      cursorColor = "${cursor}";
      cursorForegroundColor = "${background}";
      backgroundColor = "rgba(${builtins.elemAt backrgb 0}, ${builtins.elemAt backrgb 1}, ${builtins.elemAt backrgb 2}, 0.8)";
      foregroundColor = "${foreground}";
      colorsExtra = with pywal.colors;
        ''
          color0 = ${color0}
          color1 = ${color1}
          color2 = ${color2}
          color3 = ${color3}
          color4 = ${color4}
          color5 = ${color5}
          color6 = ${color6}
          color7 = ${color7}
          color8 = ${color8}
          color9 = ${color9}
          color10 = ${color10}
          color11 = ${color11}
          color12 = ${color12}
          color13 = ${color13}
          color14 = ${color14}
          color15 = ${color15}
        '';
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
    rtorrent = {
      enable = false;
      settings = ''
        directory = ~/.torrents
        session = ~/.rtsession
        min_peers = 1
        max_peers = 1000
        port_random = yes
        check_hash = no
        trackers.use_udp.set = yes
        #scheduler.max_active.set = 1
      '';
    };
    neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      withNodeJs = true;
      withRuby = false;
      vimAlias = false;
      viAlias = false;
      extraConfig = ''
        let g:NERDTreeDirArrowExpandable = '▸'
        let g:NERDTreeDirArrowCollapsible = '▾'
        let g:lightline = {
        \ 'colorscheme': 'solarized',
        \ }
        syntax on
        set number
        set mouse=a
        nnoremap <C-n> :NERDTree<CR>
        autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" |
        \ endif
      '';
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-closetag
        lightline-vim
        coc-nvim
        nerdtree
      ];
    };
    command-not-found.enable = true;
  };
  home = {
    sessionVariables = {
      EDITOR = "${config.programs.neovim.package}/bin/nvim";
      BROWSER = "${config.programs.qutebrowser.package}/bin/qutebrowser";
      TERMINAL = "${pkgs.termite}/bin/termite";
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
        (pkgs.stable.i3lock-color.overrideAttrs (attr: { patches = [ ./pkgs/patches/i3lock-color/numlock-fix.patch ./pkgs/patches/i3lock-color/white-screen-fix.patch ]; }))
      ];
    file = {
      ".config/neofetch/config.conf" = {
        text = builtins.readFile ./pkgs/config/neofetch.nix;
      };
      ".config/bpytop/bpytop.conf" = {
        text = builtins.readFile ./pkgs/config/bpytop.nix;
      };
      ".config/nixpkgs/config.nix" = {
        text = ''{ allowUnfree = true; allowBroken = true; }'';
      };
    };
    username = "dan4ik";
    homeDirectory = "/home/${config.home.username}";
  };
}
