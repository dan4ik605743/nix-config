{ lib, writeShellScriptBin, spotify, spotify-adblock }:

writeShellScriptBin "spotify" ''
  LD_PRELOAD=${spotify-adblock}/lib/spotify-adblock.so ${spotify}/bin/spotify  
''
