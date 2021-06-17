{ config
, lib
, options
, modulesPath
, pkgs
, buildLinux
, fetchFromGitHub
, ...
}:

{
  boot.kernelPackages = let
    linux_ck_pkg = { fetchFromGitHub, buildLinux, ... } @ args:
    buildLinux (args // rec {
      version = "5.4.86";
      modDirVersion = version;
      src = fetchFromGitHub 
      {
        owner = "ckolivas";
        repo = "linux";
        rev = "v${version}";
        sha256 = "0vism6a98azylidcz7cdiy4gkgmmysa2q474ry59lddxq812lgyj";
      };
      kernelPatches = [];
    } // (args.argsOverride or {}));
    linux_ck = pkgs.callPackage linux_ck_pkg{};
  in 
  pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_ck);
}
