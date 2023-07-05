{ stdenvNoCC, writeShellApplication, fetchFromGitHub, lib, xsel, rofi, xdotool }:
let 
  version = "1.2.0";
 srcs = stdenvNoCC.mkDerivation {
  name = "splatmoji";
  inherit version;

  src = fetchFromGitHub {
    owner = "cspeterson";
    repo = "splatmoji";
    rev = "v${version}";
    sha256 = lib.fakeSha256;
  };

  installPhase = ''
    cp -r * $out/
  '';
};
in writeShellApplication {
  name = "splatmoji";

  runtimeInputs = [ xsel xdotool rofi ];

  text = lib.readFile "${srcs}/splatmoji";
}
# use writeShellApplication to pass in PATH values
