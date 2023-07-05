{ stdenvNoCC, fetchurl, which, gnugrep, coreutils, gawk, lib }:
let rev = "89b6483ebfd3663cbcbd68e5e10e90e90f0bb9c2"; in stdenvNoCC.mkDerivation {
  name = "psgrep";
  
  src = fetchurl {
    url = "https://raw.githubusercontent.com/jvz/psgrep/${rev}/psgrep";
    sha256 = "sha256-45KD8YFv9QFAkoD4ei63gLmBPX5R7dwvCSB4DtpsY2I=";
  };

  buildInputs = [ which gnugrep coreutils gawk ];

  dontUnpack = true;
  installPhase = "install -D $src $out/bin/psgrep";
  fixupPhase = ''
    substituteInPlace $out/bin/psgrep --replace "PSGREP_VERSION=\"master\"" "PSGREP_VERSION=\"${rev}\""
  '';

  meta = {
    description = ''A simple little shell script to help with the "ps aux | grep" idiom.'';
    homepage = "https://github.com/jvz/psgrep";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}