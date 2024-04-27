{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:
rustPlatform.buildRustPackage rec {
  pname = "starpls";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    rev = "v${version}";
    sha256 = "sha256-cPJdESD290KTbhzrjLjYuJmdWI/IUnYZP2pyFJs21Go=";
  };

  RUSTC_BOOTSTRAP = 1;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [
    protobuf
  ];

  meta = with lib; {
    platforms = platforms.all;
  };
}
