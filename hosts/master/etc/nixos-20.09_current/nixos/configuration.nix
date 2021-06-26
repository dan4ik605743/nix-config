{ config, pkgs, lib, ... }:

let
  ## Unstable channel
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz)
    { config = config.nixpkgs.config; };
  ## Home-manager
  home-manager = (
    builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-20.09.tar.gz
  );
in
{
  imports = [
    ./hardware-configuration.nix
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
    };
  };

  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "master" ];
        keepEnv = true;
        noPass = true;
      }];
    };
  };

  home-manager = { users.master = (import ./home.nix { inherit config pkgs lib; }); };
  programs.dconf.enable = true;
  powerManagement.enable = false;
  time.timeZone = "Asia/Krasnoyarsk";
  sound.enable = true;
  nix.package = pkgs.nixStable;
  system.stateVersion = "20.03";

  networking = {
    hostName = "nixos";
    firewall.enable = false;
    dhcpcd.wait = "background";
    interfaces.wlp3s0.useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlp3s0" ];
      networks.TP-Link_D482.psk = "Qq135790-";
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  boot = {
    kernelParams = [ "mitigations=off" ];
    kernelPackages = pkgs.linuxPackages_5_4;
    supportedFilesystems = [ "xfs" "ntfs" ];
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
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
      killall
      brightnessctl
      pciutils
      usbutils
      wpa_supplicant
      p7zip
      xorg.xev
      maim
      xclip
      libva-utils
      mesa-demos
      pavucontrol
      playerctl
      nix-prefetch-scripts
      gparted
      pywal
      lm_sensors
      lxappearance
      unstable.bpytop
      unstable.neofetch
      unstable.nixpkgs-fmt

      # apps
      vlc
      qbittorrent
      wine

      # nur
      nur.repos.dan4ik605743.lyra-cursors
      nur.repos.dan4ik605743.vk-cli

      # scripts
      (pkgs.writeShellScriptBin "dotup" "doas cp -r /etc/nixos/* ~/nix-config/hosts/master/etc/nixos-20.09_current/nixos/ && echo Finish!")
    ];
  };

  services = {
    udisks2.enable = false;
    sshd.enable = true;
    udev.packages = [ pkgs.android-udev-rules ];

    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" "nouveau" ];
      libinput = {
        enable = true;
        accelProfile = "flat";
      };
      desktopManager = {
        xterm.enable = true;
      };
      displayManager = {
        defaultSession = "xterm";
        lightdm.enable = true;
        autoLogin = { enable = true; user = "master"; };
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
    users.master = {
      isNormalUser = true;
      shell = pkgs.bash;
      hashedPassword = "$6$dw6NevXRTf$/DXp5UV7RwUAsft379S6WgrcZXwgiyTot9588.14aWZLQT5FcVs0o9M6hzAHCUJvcoF10LfKHOVSVuFYuC6kP0";
      extraGroups = [ "wheel" "audio" "video" ];
    };
  };

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" "Iosevka" ]; })
      nur.repos.dan4ik605743.waffle-font
      font-awesome
      font-awesome-ttf
      noto-fonts-emoji
      unifont
      roboto
      siji
    ];
    fontconfig.localConf = import ./pkgs/config/fonts-localConf.nix;
  };
}
