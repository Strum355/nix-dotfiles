{ stdenv, fetchurl }:
let version = "2.0-pre"; in
stdenv.mkDerivation {
  src = fetchurl {
    name = "MonoStroom-Regular-${version}.ttf";
    url = "https://github.com/Strum355/MonoStroom/releases/download/v2.0-pre/MonoStroom-Regular-${version}.ttf";
    sha256 = "sha256-s9BEtT45g+lPJZY1494m51SqFB5KXy1OKVMirwZcuyM=";
  };

  pname = "MonoStroom";
  inherit version;
  dontUnpack = true;
  installPhase = "install -D $src -t $out/share/fonts/truetype/";
}
