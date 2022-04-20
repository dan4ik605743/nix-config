{ config, pkgs, lib, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
in

{
  imports = [
    ./hardware-configuration.nix
    nur.repos.dan4ik605743.modules.minidlna
  ];

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

  dan4ik605743.modules = {
    minidlna = {
      enable = true;
      rootContainer = "B";

      mediaDirs = [
        "V,/home/vds/video"
        "A,/home/vds/.music_null"
        "P,/home/vds/pictures"
      ];
    };
  };

  powerManagement.enable = false;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Krasnoyarsk";
  system.stateVersion = "20.03";

  networking = {
    hostName = "dan4ikggwp";
    nameservers = [ "8.8.8.8" ];
    defaultGateway = "192.168.0.1";
    firewall.enable = false;
    useDHCP = false;

    interfaces.enp3s0.ipv4.addresses = [{
      address = "192.168.0.111";
      prefixLength = 24;
    }];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages-libre;
    kernelParams = [ "intel_idle.max_cstate=1" "mitigations=off" ];
    supportedFilesystems = [ "xfs" "nfs" ];

    loader.grub = {
      enable = true;
      device = "/dev/sda";
      version = 2;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      vim
      git
      ncdu
      aircrack-ng
      wifite2
      inxi
      nur.repos.dan4ik605743.htop-solarized
    ];
  };

  services = {
    udisks2.enable = false;

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    transmission = {
      enable = true;

      settings = {
        rpc-port = 8000;
        download-dir = "/home/vds/video";
        incomplete-dir = "/home/vds/.incomplete-torrent";
        rpc-bind-address = "192.168.0.111";
        rpc-authentication-required = false;
        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
      };
    };

    nfs.server = {
      enable = true;

      exports = ''
        /export         192.168.0.0/24(rw,fsid=0,no_subtree_check)
        /export/home    192.168.0.0/24(rw,nohide,insecure,no_subtree_check)  
      '';
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

    users.vds = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$oq/JC6rW2oobcJq.$2SimyNpyNY4BIT5b1ydsiFlCWvKpPKGQZEE3TBN.um0eYAyNlNInwUXJArmToxHTnImp6XsnlmvHg2NTVrOGY/";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOIuIutmkslaS/C6seRY1Pg/416wekBGcE7USHUoxK+ dan4ik" ];
    };
  };
}
