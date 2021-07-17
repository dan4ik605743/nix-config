final: prev: {
  spotify-adblock = prev.callPackage ./spotify/spotify-adblock.nix { };

  spotify-wrapped = prev.callPackage ./spotify/spotify-wrapped.nix {
    inherit (final.unstable) spotify;
    spotify-adblock = final.spotify-adblock;
  };
}
