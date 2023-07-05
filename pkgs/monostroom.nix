{ stdenvNoCC, fetchurl, lib }:
let version = "2.0-pre";
in stdenvNoCC.mkDerivation {
  pname = "MonoStroom";
  inherit version;

  src = fetchurl {
    name = "MonoStroom-Regular-${version}.ttf";
    url =
      "https://github.com/Strum355/MonoStroom/releases/download/v${version}/MonoStroom-Regular-${version}.ttf";
    sha256 = "sha256-s9BEtT45g+lPJZY1494m51SqFB5KXy1OKVMirwZcuyM=";
  };

  dontUnpack = true;
  installPhase = "install -D $src -t $out/share/fonts/truetype/";

  meta = {
    description = "An Inconsolata modification font with ligatures.";
    homepage = "https://github.com/Strum355/MonoStroom";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
