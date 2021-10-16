{ config, pkgs, lib, inputs, ... }:

{
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 40;
    priority = 10;
    swapDevices = 1;
  };

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        groups = [ "wheel" ];
        keepEnv = true;
        noPass = true;
      }];
    };
  };

  nix = rec {
    package = pkgs.nixFlakes;
    trustedBinaryCaches = binaryCaches;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=/etc/nixos/system/configuration.nix"
      "home-manager=${inputs.home}"
    ];
    trustedUsers = [
      "root"
      "dan4ik"
      "@wheel"
    ];
    binaryCaches = [
      "https://cache.nixos.org?priority=10"
      "https://cache.ngi0.nixos.org/"
      "https://emacsng.cachix.org"
      "https://mjlbach.cachix.org"
      "https://nix-community.cachix.org"
      "https://dan4ik605743.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
      "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI="
      "mjlbach.cachix.org-1:dR0V90mvaPbXuYria5mXvnDtFibKYqYc2gtl9MWSkqI="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "dan4ik605743.cachix.org-1:rhJb/S+2G33sj0wR2fXp0WqMKPCYHpeWG2AjS4dwUaA="
    ];
    registry = {
      system.flake = inputs.self;
      default.flake = inputs.nixpkgs;
      home-manager.flake = inputs.home;
    };
    optimise = {
      automatic = true;
      dates = [ "13:00" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "-d";
    };
  };

  programs = {
    dconf.enable = true;
    steam.enable = true;
    java = {
      enable = true;
      package = pkgs.jre;
    };
  };

  powerManagement.enable = false;
  time.timeZone = "Asia/Krasnoyarsk";
  system.stateVersion = "20.03";

  networking = {
    hostName = "nixos";
    firewall.enable = false;
    useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlp3s0" ];
      networks = {
        TP-Link_D482.psk = "Qq135790-";
        huawei.psk = "zxcursed";
      };
    };
    interfaces = {
      enp2s0f2.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    dhcpcd = {
      enable = true;
      wait = "background";
    };
  };

  hardware = {
    bluetooth.enable = false;
    cpu.intel.updateMicrocode = true;
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
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" ];
    supportedFilesystems = [ "xfs" "ntfs" ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        version = 2;
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # system
      wget
      feh
      jmtpfs
      bpytop
      brightnessctl
      pciutils
      usbutils
      wpa_supplicant
      p7zip
      maim
      xclip
      libva-utils
      mesa-demos
      jdk
      gparted
      pywal
      lm_sensors
      lxappearance
      ncdu
      pfetch
      vk-cli
      ranger
      aircrack-ng
      tree
      winetricks
      screen
      nodejs
      llpp
      xorg.xev

      # apps
      pinta
      vlc
      wpsoffice
      qbittorrent
      ripcord
      discord
      lutris
      vk-messenger
      gimp
      viber
      teamspeak_client
      multimc

      # nur
      nur.repos.dan4ik605743.lyra-cursors
      nur.repos.dan4ik605743.i3lock-color

      # nix-tools
      nix-prefetch-scripts
      nix-tree
      rnix-lsp
      nixpkgs-fmt
      nixpkgs-review
      patchelf

      # audio-tools
      alsa-utils
      pavucontrol
      pulseaudio
      playerctl
      cmus

      # dotnet
      dotnet-sdk
      dotnet-netcore
      dotnet-aspnetcore

      # scripts
      (pkgs.writeShellScriptBin "dotup" "doas cp -r /etc/nixos/* ~/git/nix-config/hosts/dan4ik/etc/nixos/ && echo Finish!")
      (pkgs.writeShellScriptBin "prime-run" ''__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"'')
    ];
  };

  services = {
    udisks2.enable = false;
    blueman.enable = false;
    openssh.enable = true;
    urxvtd.enable = true;
    udev.packages = [ pkgs.android-udev-rules ];

    zerotierone = {
      enable = true;
      joinNetworks = [ "17d709436cd7dbb5" ];
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      synaptics = {
        enable = true;
        twoFingerScroll = true;
        buttonsMap = [ 1 0 3 ];
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
    users.dan4ik = {
      isNormalUser = true;
      shell = pkgs.bash;
      hashedPassword = "$6$JXAfjAuNeCsxAF5e$pUbTjZ9mVOw8rdk/61ZvzT1RaRLrY2qamAiopPneYvrJa6SnAIHHNM3UJ6Ie1mU6v/a8t6z2CBjyVS4F1yqlh.";
      extraGroups = [ "wheel" "audio" "video" ];
    };
  };

  fonts = {
    fonts = with pkgs; [
      nur.repos.dan4ik605743.bitmap-fonts
      nur.repos.fortuneteller2k.iosevka-ft-bin
      font-awesome
      font-awesome-ttf
      noto-fonts-emoji
      jetbrains-mono
      unifont
      roboto
      hack-font
      siji
    ];
    fontconfig = {
      enable = true;
      defaultFonts.emoji = [ "Noto Color Emoji" ];
    };
  };
}
