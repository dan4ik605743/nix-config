final: prev: {
  winetricks = prev.winetricks.override {
    wine = prev.wineWowPackages.staging;
  };
  ripgrep = prev.ripgrep.override {
    withPCRE2 = true;
  };
  viber = prev.viber.overrideAttrs (attr: {
    src = prev.fetchurl {
      url = "https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb";
      sha256 = "sha256-EDekjXTK7zPRI7Fm2iv7H+j6Z1kLhmns8lsxT0E3Qmc=";
    };
  });
}
