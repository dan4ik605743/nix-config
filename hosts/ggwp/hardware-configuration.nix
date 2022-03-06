{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/bec593c5-07c9-4c93-a110-9538f3df6a4a";
    fsType = "xfs";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ed1a9b5f-a06d-426b-a691-a9adf29f7b7a";
    fsType = "xfs";
  };

  /*
  fileSystems."/home/dan4ik/nfs" = {
    device = "192.168.0.111:/export/home";
    options = [ "x-systemd.idle-timeout=300" "x-systemd.automount" "noauto" ];
    fsType = "nfs";
  };
  */

  swapDevices = [ ];
}
