{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  swapDevices = [{ device = "/dev/disk/by-uuid/4a7f3e25-14ab-4d4d-acb7-ead150d11b9d"; }];
  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c5fa39f9-b4a3-442d-a627-1b9d4316ede4";
    fsType = "xfs";
  };

  fileSystems."/export/home" = {
    device = "/home/vds";
    options = [ "bind" ];
  };
}
