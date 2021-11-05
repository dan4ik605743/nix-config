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

  programs.dconf.enable = true;
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
        huawei.psk = "zxcursed";
      };
    };

    interfaces = {
      enp4s0.useDHCP = true;
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
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" ];
    supportedFilesystems = [ "xfs" "ntfs" ];

    loader.grub = {
      enable = true;
      device = "/dev/sda";
      version = 2;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      # system
      wget
      feh
      git
      jmtpfs
      bpytop
      pciutils
      usbutils
      wpa_supplicant
      p7zip
      maim
      xclip
      libva-utils
      mesa-demos
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
      llpp
      xorg.xev

      # apps
      pinta
      vlc
      wpsoffice
      qbittorrent
      discord
      lutris
      vk-messenger
      viber
      teamspeak_client

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

      # neovim
      neovim
      fzf
      file
      nodejs
      yarn
      ctags

      # c#
      dotnet-sdk
      dotnet-netcore
      dotnet-aspnetcore
      omnisharp-roslyn
      mono

      # nur
      nur.repos.dan4ik605743.i3lock-color

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
      videoDrivers = [ "modesetting" "nouveau" ];
      synaptics.enable = true;
      desktopManager.xterm.enable = true;

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
