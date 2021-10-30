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

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D145-64C7";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/f6cd5564-0748-43b0-a4d4-9921b1705f66";
      fsType = "xfs";
    };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b6ba13a7-3367-4704-b2cd-fb0de6007020";
      fsType = "xfs";
    };

  swapDevices = [ ];
}
