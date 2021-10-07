final: prev: {
  winetricks = prev.winetricks.override {
    wine = prev.wineWowPackages.staging;
  };
}
