{ config, pkgs, lib, ... }:

{
  qt5 = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
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
    wireless.enable = false;

    networkmanager = {
      enable = true;
      dns = "none";
      packages = [ pkgs.networkmanagerapplet ];
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;
    usbWwan.enable = true;
    bluetooth.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" ];
    supportedFilesystems = [ "xfs" "ntfs" ];
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
      gparted
      lm_sensors
      lxappearance
      ncdu
      pfetch
      aircrack-ng
      tree
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
      clang
      ccls

      # sddm
      libsForQt5.plasma-framework
      libsForQt5.qt5.qtgraphicaleffects
      libsForQt5.qt5.qtquickcontrols

      # nur
      nur.repos.dan4ik605743.i3lock-color
      nur.repos.dan4ik605743.sddm-chili
    ];
  };

  services = {
    udisks2.enable = false;
    urxvtd.enable = true;
    blueman.enable = true;
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
      synaptics.enable = true;
      desktopManager.xterm.enable = true;

      displayManager = {
        defaultSession = "xterm";

        autoLogin = {
          enable = true;
          user = "dan4ik";
        };

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
      hashedPassword = "$6$PEqqH.Wc$mJT.Wm/1KQN.9obVBFxr1cOK5HlakSGtoVQisNmyOStLOd1.we9uGgUbmYutloN5zdMnK994xOkhVwTdrmisp.";
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
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
