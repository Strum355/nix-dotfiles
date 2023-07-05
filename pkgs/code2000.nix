{ stdenvNoCC, fetchzip, lib }:
stdenvNoCC.mkDerivation {
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

  meta = {
    description = "Code2000 is a serif and pan-Unicode digital font, which includes characters and symbols from a very large range of writing systems.";
    homepage = "https://www.code2000.net/";
    downloadPage = "https://web.archive.org/web/20101122151653/http://code2000.net/CODE2000.ZIP";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.all;
  };
}
