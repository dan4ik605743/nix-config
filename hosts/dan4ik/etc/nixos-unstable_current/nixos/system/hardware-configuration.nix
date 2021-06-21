{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/sda5";
      fsType = "xfs";
    };

  fileSystems."/home" =
    {
      device = "/dev/sda6";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    {
      device = "/dev/sda2";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
