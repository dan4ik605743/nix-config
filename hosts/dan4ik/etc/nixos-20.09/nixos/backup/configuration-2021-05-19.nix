{ config, pkgs, lib, ... }:

let
  ## Unstable channel
  unstable = import
  (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz)
  { config = config.nixpkgs.config; };
  ## FontConfig
  fontconf = pkgs.fetchurl {
    url = "https://git.sr.ht/~dan4ik605743/dotfiles/blob/master/home/dan4ik/.config/fontconfig/fonts.conf";
    sha256 = "0aqzf5hkffywfqb40lrvjjxxlgja349b1kldagc0r65m95nhwij4";
  };
in
  {
    imports = [
      ./kernel.nix
      ./hardware-configuration.nix
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.09.tar.gz}/nixos")
    ];
    
    nixpkgs.config = {
      allowUnfree = true;
      allowBroken = true;
    };

    qt5 = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    zramSwap = {
      enable = true;
      memoryPercent = 40;
      priority = 10;
      swapDevices = 1;
    };

    virtualisation = {
      virtualbox.host = {
        enable = false;
      };
    };

    home-manager = { users.dan4ik = (import ./home.nix {inherit config pkgs lib unstable;}); };
    programs.dconf.enable = true;
    security.sudo.wheelNeedsPassword = false;
    time.timeZone = "Asia/Krasnoyarsk";
    sound.enable = true;
    system.stateVersion = "20.03";

    networking = {
      hostName = "nixos";
      firewall.enable = false;
      dhcpcd.wait = "background";
      nameservers = [ "1.1.1.1" ];
      hostId = "046858ef";
      wireless = {
        enable = false;
        interfaces = [ "wlp3s0" ];
        networks.TP-Link_D482.psk = "Qq135790-";
      };
    };

    hardware = {
      bluetooth.enable = false;
      pulseaudio = {
        enable = true;
        support32Bit = true;
      };
      opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
      nvidia.prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:4:0:0";
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    boot = {
      kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" "zfs.zfs_arc_max=1555555555" ];
      #kernelModules = [ "kvm-intel" ];
      supportedFilesystems = [ "xfs" "zfs" ];
      initrd.supportedFilesystems = [ "zfs" ];
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          consoleMode = "2";
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
      # system
      wget 
      htop bpytop
      feh
      ntfs3g jmtpfs  
      killall 
      brightnessctl 
      pciutils usbutils 
      wpa_supplicant
      p7zip
      xorg.xev 
      maim xclip
      libva-utils mesa-demos 
      pavucontrol playerctl
      nix-prefetch-git nix-index patchelf
      gparted 
      pywal
      lm_sensors
      neofetch

      # apps
      pinta vlc transmission wpsoffice unstable.viber

      # game
      steam steam-run lutris wine winetricks vulkan-loader vulkan-headers vulkan-tools

      (callPackage ./packages/my-cursor.nix {})
      (callPackage ./packages/vk-cli.nix {})

      (pkgs.writeShellScriptBin "prime-run" '' __NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia "$@" '')
      (pkgs.writeShellScriptBin "minecraft" '' nix-shell ~/Documents/minecraft/default.nix --run "prime-run java -jar ~/Documents/minecraft/TL.jar" '')
      (pkgs.writeShellScriptBin "flatout2" '' prime-run steam-run ./Documents/gog\ games/FlatOut\ 2/start.sh -w '')
      (pkgs.writeShellScriptBin "dotup" '' sudo cp -r /etc/nixos/ ~/dotfiles/etc/ && echo Finish! '')
    ];
  };

    services = {
      blueman.enable = true;
      udisks2.enable = false;
      teamviewer.enable = false;
      udev.packages = [ pkgs.android-udev-rules ];

      zfs = {
        autoScrub.enable = false;
        autoSnapshot.enable = false;
      };

      openvpn = {
        #servers = {
        #  freeVPN = { config = ''config /home/dan4ik/Documents/freevpn/Server1-UDP53.ovpn''; };
        #};
      };
      
      xserver = {
        enable = true;
        videoDrivers = [ "nvidia" ];
        synaptics = {
          enable = true;
          twoFingerScroll = true;
          tapButtons = false;
          additionalOptions = ''
            Option "TapButton1" "1"
            Option "TapButton2" "0"
            Option "TapButton3" "3"
            '';
          };
        desktopManager = {
          xterm.enable = true;
        };
        displayManager = {
          defaultSession = "xterm";
          lightdm = {
            enable = true;
            greeters.mini = {
              enable = true;
              user = "dan4ik";
              extraConfig = ''
                [greeter]
                show-password-label = false
                [greeter-theme]
                background-image = ""
                '';
              };
            };
          };
        };
      logind = {
        extraConfig = "HandlePowerKey=suspend";
        lidSwitch = "ignore";
        lidSwitchDocked = "ignore";
        lidSwitchExternalPower = "ignore";
      };
    };

    users = {
      mutableUsers = false;
      extraGroups.vboxusers.members = [ "dan4ik" ];
      users.dan4ik = {
        isNormalUser = true;
        shell = pkgs.zsh;
        hashedPassword = "$6$JXAfjAuNeCsxAF5e$pUbTjZ9mVOw8rdk/61ZvzT1RaRLrY2qamAiopPneYvrJa6SnAIHHNM3UJ6Ie1mU6v/a8t6z2CBjyVS4F1yqlh.";
        extraGroups = [ "wheel" "audio" "video" ];    
      };
    };

    fonts = {
      fonts = with pkgs; [
        (nerdfonts.override{fonts = ["JetBrainsMono" "Iosevka"];})
        (callPackage ./packages/waffle-font.nix {})
        font-awesome
        font-awesome-ttf
        noto-fonts-emoji
        unifont
        roboto
        siji
      ];
      fontconfig.localConf = builtins.readFile "${fontconf}";
    };
}
