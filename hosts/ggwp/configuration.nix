{ config, pkgs, lib, ... }:

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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
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

  sound = {
    enable = true;

    extraConfig = ''
      defaults.pcm.card 2
      defaults.ctl.card 2
    '';
  };

  programs = {
    dconf.enable = true;
    adb.enable = true;
  };

  powerManagement.enable = false;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Krasnoyarsk";
  system.stateVersion = "20.03";

  networking = {
    hostName = "ggwp";
    firewall.enable = false;
    useDHCP = true;

    wireless = {
      enable = false;
      interfaces = [ "wlp3s0" ];

      networks = {
        TP-Link_D482.psk = "Qq135790-";
        note4.psk = "zxcursed";
      };
    };

    interfaces = {
      wlp3s0.useDHCP = true;

      enp2s0f2 = {
        useDHCP = true;

        ipv4.addresses = [{
          address = "192.168.0.110";
          prefixLength = 16;
        }];
      };
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

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:4:0:0";
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" ];
    supportedFilesystems = [ "xfs" "ntfs" "nfs" ];

    loader.grub = {
      enable = true;
      device = "/dev/sda";
      version = 2;
    };

    extraModprobeConfig = ''
      options snd_hda_intel enable=0,1
    '';
  };

  environment = {
    systemPackages = with pkgs; [
      # system
      wget
      feh
      git
      pciutils
      usbutils
      alsa-utils
      playerctl
      cmus
      wpa_supplicant
      p7zip
      maim
      xclip
      libva-utils
      mesa-demos
      lxappearance
      ncdu
      pfetch
      aircrack-ng
      tree
      wine
      llpp
      libnotify
      tigervnc
      agenix
      inxi
      xorg.xev

      # apps
      pinta
      vlc
      wpsoffice
      qbittorrent
      viber
      gimp

      # nix-tools
      nix-prefetch-scripts
      nix-tree
      rnix-lsp
      nixpkgs-fmt
      nixpkgs-review
      patchelf

      # neovim
      neovim
      fzf
      file
      nodejs
      yarn
      ctags

      # c++
      gcc
      clang-tools
      vscode-extensions.vadimcn.vscode-lldb

      # sddm
      libsForQt5.plasma-framework
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtquickcontrols

      # nur
      nur.repos.dan4ik605743.i3lock-color
      nur.repos.dan4ik605743.sddm-chili
      nur.repos.dan4ik605743.simp1e-cursors

      # scripts
      (pkgs.writeShellScriptBin "dotup" "doas cp -r /etc/nixos/* ~/git/nix-config/ && echo Finish!")
      (pkgs.writeShellScriptBin "nvidia-offload" ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec -a "$0" "$@" 
      '')
    ];
  };

  services = {
    udisks2.enable = false;
    openssh.enable = false;
    urxvtd.enable = true;
    udev.packages = [ pkgs.android-udev-rules ];

    zerotierone = {
      enable = true;
      joinNetworks = [ "17d709436cd7dbb5" ];
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      synaptics.enable = true;
      desktopManager.xterm.enable = true;

      displayManager = {
        defaultSession = "xterm";

        sddm = {
          enable = true;
          theme = "sddm-chili";
        };
      };
    };

    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = "HandlePowerKey=suspend";
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
      noto-fonts-emoji
      jetbrains-mono
      cascadia-code
      font-awesome
      hack-font
      unifont
      roboto
    ];

    fontconfig = {
      enable = true;
      defaultFonts.emoji = [ "Noto Color Emoji" ];
    };
  };
}
