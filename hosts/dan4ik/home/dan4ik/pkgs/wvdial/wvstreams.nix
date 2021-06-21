{}:

with import <nixpkgs> { };

stdenv.mkDerivation
{
  name = "wvstreams";
  src = fetchurl
    {
      url = "https://archlinux.org/packages/community/x86_64/wvstreams/download/";
      sha256 = "06d7c5kqr7icpfwpwd65xsw4gyx9qbl688axm44nfnh6ipj3fk75";
    };
  unpackPhase =
    ''
      mkdir -p $out/lib
      tar xfvJ $src -C $out
    '';
  nativeBuildInputs =
    [
      xz
      autoPatchelfHook
    ];
  buildInputs =
    [
      (stdenv.mkDerivation
        {
          name = "openssl-1.0";
          src = fetchurl
            {
              url = "https://archlinux.org/packages/core/x86_64/openssl-1.0/download/";
              sha256 = "14n659lygdvnkdv8184mp4z95f76yfhb2frpfymmybi2dkiw9zwa";
            };
          unpackPhase =
            ''
              mkdir -p $out/lib
              tar -I zstd -xvf $src -C $out
            '';
          nativeBuildInputs =
            [
              zstd
              autoPatchelfHook
            ];
          installPhase =
            ''
              mv $out/usr/lib/* $out/lib
            '';
        })
      pam
      readline80.out
      zlib
      gcc-unwrapped
    ];
  installPhase =
    ''
      mv $out/usr/lib/* $out/lib/ 
    '';
}
