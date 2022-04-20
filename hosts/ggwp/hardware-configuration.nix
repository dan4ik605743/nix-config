{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/df4c121b-04d0-40cb-8a0f-d40523d16566";
    fsType = "xfs";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/a5a9b9f4-25ad-4dc0-a93a-fc1872150ea9";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6492-6B39";
    fsType = "vfat";
  };

  fileSystems."/home/dan4ik/nfs" = {
    device = "192.168.0.111:/export/home";
    options = [ "x-systemd.automount" "noauto" ];
    fsType = "nfs";
  };
}
