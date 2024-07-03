{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:
rustPlatform.buildRustPackage rec {
  pname = "starpls";
  version = "0.1.14-unstable-2024-08-03";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    # rev = "v${version}";
    rev = "538d55bc3d209692118c4d6770b7f5861fb0f888";
    sha256 = "sha256-om4lYGWcUavYwJxHNjQ1Oy6dANJOimvEEt9tlhRDS0A=";
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
