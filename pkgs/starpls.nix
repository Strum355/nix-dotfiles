{ lib
, rustPlatform
, fetchFromGitHub
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "starpls";
  version = "0.1.11-unstable-2024-04-17";

  src = fetchFromGitHub {
    owner = "withered-magic";
    repo = "starpls";
    rev = "7eac4b62748dbae714e374aca9922c2fc6dc6cc0";
    sha256 = "sha256-XJGJ9RPA6mZP/CqbnrjHdONB+otHyRKeyA8CbJt2l1M=";
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
