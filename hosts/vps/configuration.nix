{ config, pkgs, lib, ... }:

let
  nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") { inherit pkgs; };
in

{
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

  imports = [ ./hardware-configuration.nix ];
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Krasnoyarsk";
  system.stateVersion = "20.03";

  networking = {
    hostName = "dan4ikggwp";
    usePredictableInterfaceNames = false;
    defaultGateway = "213.183.51.1";
    resolvconf.enable = false;
    useDHCP = false;

    nat = {
      enable = true;
      externalInterface = "eth0";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowPing = false;
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 50020 ];
    };

    wg-quick.interfaces.wg0 = {
      address = [ "10.0.0.1/24" ];
      listenPort = 50020;
      privateKeyFile = "/home/vps/wireguard-keys/private";
      mtu = 1412;

      postUp = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      '';

      preDown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o eth0 -j MASQUERADE
      '';

      peers = [
        {
          # dan4ik
          publicKey = "rE/QevWcYaymhqlGrBOuhJi6RKKDNKlXOCxybHAvlCM=";
          allowedIPs = [ "10.0.0.2/32" ];
        }
        {
          # smartphone
          publicKey = "4stV6w2y0SPNQIcRBxWrY8+HTe0SfblbbnOtvv36g3M=";
          allowedIPs = [ "10.0.0.3/32" ];
        }
      ];
    };

    interfaces.eth0.ipv4.addresses = [{
      address = "213.183.51.195";
      prefixLength = 24;
    }];
  };

  boot = {
    kernelPackages = pkgs.linuxPackages-libre;
    kernelParams = [ "mitigations=off" ];
    supportedFilesystems = [ "xfs" ];

    loader.grub = {
      enable = true;
      device = "/dev/vda";
      version = 2;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      wget
      vim
      git
      wireguard-tools
      nur.repos.dan4ik605743.htop-solarized
    ];
  };

  services = {
    udisks2.enable = false;

    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    dnsmasq = {
      enable = true;

      extraConfig = ''
        domain-needed
        bogus-priv
        no-resolv

        server=1.1.1.1
        listen-address=127.0.0.1
        interface=wg0

        cache-size=10000
        log-queries
        log-facility=/tmp/ad-block.log
        local-ttl=300

        addn-hosts=/home/vps/hosts-blocklists/hostnames.txt
      ''; ## add-conf sets default in module dnsmasq
    };
  };

  users = {
    mutableUsers = false;

    users.vps = {
      isNormalUser = true;
      shell = pkgs.bash;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKOIuIutmkslaS/C6seRY1Pg/416wekBGcE7USHUoxK+ dan4ik" ];
    };
  };
}
