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
    nameservers = [ "1.1.1.1" ];
    defaultGateway = "192.168.0.1";
    firewall.enable = false;
    useDHCP = false;

    wg-quick.interfaces.wg0 = {
      address = [ "10.0.0.2/24" ];
      dns = [ "10.0.0.1" ];
      listenPort = 50020;
      privateKeyFile = "/home/dan4ik/.wireguard-keys/private";

      peers = [{
        publicKey = "Cc44DBfY0VBv1aNxlHk3CYdL6TFbaAnM+BJZurjfey0=";
        allowedIPs = [ "0.0.0.0/0" ];
        endpoint = "dan4ikggwp.koise.pw:50020";
      }];
    };

    interfaces.enp2s0f2.ipv4.addresses = [{
      address = "192.168.0.110";
      prefixLength = 24;
    }];
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
  };

  boot = {
    kernelPackages = pkgs.linuxPackages-libre;
    kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" ];
    blacklistedKernelModules = [ "snd_hda_intel" "snd_hda_codec_realtek" ];
    supportedFilesystems = [ "xfs" "ntfs" "nfs" ];

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    };
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
      tree
      wine
      llpp
      libnotify
      agenix
      inxi
      tty-clock
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
      gdb
      clang-tools

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
      videoDrivers = [ "modesetting" "nouveau" ];
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
