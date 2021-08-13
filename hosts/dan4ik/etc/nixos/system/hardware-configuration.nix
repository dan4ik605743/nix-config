{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/560E-4C4B";
      fsType = "vfat";
    };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/6d2b6c02-fcfb-4572-bd47-00a704fd284c";
      fsType = "xfs";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/6db079d5-ca79-4936-a895-d57b59178f97";
      fsType = "xfs";
    };

  swapDevices = [ ];

}
