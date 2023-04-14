{ stdenv, fetchzip }:
stdenv.mkDerivation {
  src = fetchzip {
    extension = "zip";
    stripRoot = false;
    name = "CODE2000.ZIP";
    url = "https://web.archive.org/web/20101122151653/http://code2000.net/CODE2000.ZIP";
    sha256 = "sha256-gaL0X2CpH53UHC9+MsYHbVKTiG5xPMY/1NPrh5+ov0o=";
  };

  pname = "Code2000";
  version = "1.171";
  dontUnpack = true;
  installPhase = "install -D $src/CODE2000.TTF -t $out/share/fonts/truetype";
}
