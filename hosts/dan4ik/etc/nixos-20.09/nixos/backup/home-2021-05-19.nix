{ config, pkgs, lib, unstable, ... }:

let
  ## Zsh
  myzsh = pkgs.callPackage ./packages/myzsh.nix {};
  ## Qutebrowser 
  qutetheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/theova/base16-qutebrowser/main/themes/minimal/base16-classic-dark.config.py";
    sha256 = "0sdysari2nsbzwc9sha48y7lc48j87hlvpscdnwzy95wb4bj0gz5";
  };
  ## Pywal
  color = pkgs.callPackage ./packages/pywal/pywal.nix {};
  pywal = builtins.fromJSON (builtins.readFile "${color}/colors.json");
  backrgb = builtins.match ".*Colour2\"=\"([0-9]+),([0-9]+),([0-9]+)\".*$" (builtins.readFile "${color}/colors-putty.reg"); 
  rofi-theme = builtins.readFile "${color}/colors-rofi-dark.rasi";
  polybar-colors = builtins.fromJSON (builtins.readFile "${color}/polybar.json");
  ## Gtk
  generated = with pkgs; stdenv.mkDerivation rec 
  {
    name = "generated";
    src = fetchFromGitHub 
    {
      owner = "themix-project";
      repo = "oomox";
      rev = "1.12.5.3";
      sha256 = "0xz2j6x8zf44bjsq2h1b5105h35z8mbrh8b97i5z5j0zb8k5zhj2";
      fetchSubmodules = true;
    };
    dontBuild = true;
    nativeBuildInputs =  
    [ 
      glib 
      libxml2 
      bc 
    ];
    buildInputs =  
    [ 
      gnome3.gnome-themes-extra 
      gdk-pixbuf 
      librsvg 
      sassc 
      inkscape 
      optipng 
    ];
    propagatedUserEnvPkgs =
    [
      gtk-engine-murrine 
    ];
    installPhase = with pywal.special;
    with pywal.colors;
    let
      toRGB = x: lib.removePrefix "#" x;
    in
    ''
    # gtk theme
    mkdir -p $out/share/themes/generated
    pushd plugins/theme_oomox/gtk-theme
    patchShebangs .
    echo "
    BG=${toRGB background}
    FG=${toRGB foreground}
    MENU_BG=${toRGB background}
    MENU_FG=${toRGB background}
    HDR_BG=${toRGB background}
    HDR_FG=${toRGB foreground}
    HDR_BTN_BG=${toRGB background}
    HDR_BTN_FG=${toRGB foreground}
    SEL_BG=${toRGB color9}
    SEL_FG=${toRGB foreground}
    TXT_BG=${toRGB background}
    TXT_FG=${toRGB foreground}
    BTN_BG=${toRGB background}
    BTN_FG=${toRGB foreground}
    HDR_BTN_BG=${toRGB background}
    HDR_BTN_FG=${toRGB foreground}
    WM_BORDER_WIDTH=0
    ROUNDNESS=8
    SPACING=4
    GRADIENT=0
    GTK3_GENERATE_DARK=True
    CARET1_FG=${toRGB foreground}
    CARET2_FG=${toRGB background}
    CARET_SIZE=0.08
    " > /build/source/generated.colors
    HOME=/build/source ./change_color.sh -o generated -t $out/share/themes /build/source/generated.colors
    popd
    '';
  };
in
  { 
    nixpkgs.config = config.nixpkgs.config;
      xsession = {
        enable = true;
        numlock.enable = true;
        initExtra = ''
          xrandr --output eDP-1 --off
          synclient TouchpadOff=1
          xset s off && xset dpms 0 0 0
          '';
          windowManager.i3 = with pywal.colors; {
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
                "${modifier}+F2" = "exec viber";
                "${modifier}+F11" = "exec screenlock";
                "${modifier}+F10" = "exec ${terminal} -e htop";
                "${modifier}+Print" = "exec maim -u ~/.cache/u.png && cat ~/.cache/u.png| xclip -selection clipboard -t image/png";
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
                "Print" = "exec maim -su ~/.cache/su.png && cat ~/.cache/su.png| xclip -selection clipboard -t image/png";
              };
              startup = [
                {
                  command = "exec i3-msg workspace 1";
                  always = false;
                  notification = false;
                }
                {
                  command = "${pkgs.feh}/bin/feh --bg-scale /etc/nixos/packages/pywal/wallpaper";
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
            package = "${generated}";
            name = "generated";
          };
          gtk3 = {
            extraCss = ''
              VteTerminal, vte-terminal {
              padding: 15px;
              }
              '';
              extraConfig = {
                gtk-cursor-theme-name = "LyraG-cursors";
                gtk-cursor-theme-size = 0;
              };
            };
            gtk2.extraConfig = ''
              gtk-cursor-theme-name="LyraG-cursors"
              gtk-cursor-theme-size=0
              '';
        };
        services = with pywal.special; with polybar-colors.special; {
          polybar = let
            ac = "#4DD0E1";
            bg = "${background1}";
            fg = "${foreground}";
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
          in {
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
                label-focused-underline = orange;
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
            package = pkgs.callPackage ./packages/compton.nix {};
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
          };
        };
        programs = {
          neovim = {
            enable = true;
            withNodeJs = true;
            withPython = false;
            withPython3 = false;
            withRuby = false;
            vimAlias = false;
            viAlias = false;
            configure = {
              customRC = ''
                let g:NERDTreeDirArrowExpandable = '▸'
                let g:NERDTreeDirArrowCollapsible = '▾'
                let g:lightline = {
                \ 'colorscheme': 'seoul256',
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
                plug.plugins = with pkgs.vimPlugins; [
                  vim-nix
                  vim-closetag
                  lightline-vim
                  coc-nvim
                  nerdtree
                ];
              };
            };
            zsh = {
              enable = true;
              initExtra = ''
                export ZSH=${myzsh}/share/oh-my-zsh
                ZSH_THEME="my"
                plugins=(git sudo fast-syntax-highlighting zsh-autosuggestions)
                source $ZSH/oh-my-zsh.sh
                export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 ## osu-lazer
                '';
              shellGlobalAliases = {
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
                 config.source('${qutetheme}')
                 '';
             };
             vscode = {
               enable = true;
               package = unstable.vscode;
               extensions = with unstable.vscode-extensions;
               [
                 ms-vscode.cpptools
                 bbenoist.Nix
                 pkief.material-icon-theme
               ]++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
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
                 "telemetry.enableCrashReporter" =  "false";
                 "terminal.integrated.shell.linux" = "${pkgs.zsh}/bin/zsh";
                 "workbench.iconTheme" = "material-icon-theme";
                 "workbench.colorTheme" = "Monokai Pro (Filter Ristretto)";
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
             google-chrome.enable = true;
           };
        home = {
          sessionVariables = {
            EDITOR = "nvim";
            BROWSER = "qutebrowser";
            TERMINAL = "termite";
            XDG_DESKTOP_DIR = "/home/dan4ik/Downloads";
            XDG_DOWNLOAD_DIR = "/home/dan4ik/Downloads";
            XDG_PICTURES_DIR = "/home/dan4ik/Downloads";
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
            myscreenlock (i3lock-color.overrideAttrs(attr:{patches = [ ./packages/patches/i3lock-color/numlock-fix.patch ./packages/patches/i3lock-color/white-screen-fix.patch ];}))
          ];
        };
}
