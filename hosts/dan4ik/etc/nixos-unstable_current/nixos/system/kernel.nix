{ config
, lib
, options
, inputs
, modulesPath
, pkgs
, buildLinux
, fetchFromGitHub
, ...
}:

{
  boot.kernelPackages = 
  let
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
  (pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_ck)).extend (linuxSelf: linuxSuper:
  let
    generic = args: linuxSelf.callPackage (import "${inputs.nixpkgs}/pkgs/os-specific/linux/nvidia-x11/generic.nix" args) { };
  in
  {
    nvidiaPackages.stable = generic {
      version = "455.38";
      sha256_64bit = "0x6w2kcjm5q9z9l6rkxqabway4qq4h3ynngn36i8ky2dpxc1wzfq";
      settingsSha256 = "1hk4yvbb7xhfwm8jiwq6fj5m7vg3w7yvgglhfyhq7bbrlklfb4hm";
      persistencedSha256 = "00mmazv8sy93jvp60v7p954n250f4q3kxc13l4f8fmi28lgv0844";
    };
  });
}
