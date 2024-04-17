{ lib, hddtemp, systemd, python3, python3Packages, fetchFromGitHub }:
python3Packages.buildPythonApplication rec {
  pname = "wdnas-hwdaemon";
  version = "2023-03-15_9fc0596";
  format = "other";

  src = fetchFromGitHub {
    owner = "michaelroland";
    repo = "wdnas-hwdaemon";
    rev = "9fc05963b05b2f50b5c19b14c3776b4f1545a0a4";
    sha256 = "sha256-wk7a8PTmynv3i6Et1qiZo+EMZnyotU+JhNPvK48JI2Q=";
  };

  dependencies = with python3Packages; [
    pyserial
    smbus2
  ];

  # we're not moving anything besides $src/bin stuff to $out,
  # so we patch other stuff in the patch phase instead of fixupPhase.
  postPatch = ''
    # we can go lower than 20 :smugcat:
    substituteInPlace lib/wdhwlib/fancontroller.py \
      --replace-fail 'FAN_MIN = 20' 'FAN_MIN = 10'
  '';

  # needed to satisfy buildPythonApplication
  preBuild = ''
    echo "" > setup.py
  '';

  installPhase = ''
    install -Dm755 bin/wdhwd $out/bin/wdhwd
    install -Dm755 bin/wdhwc $out/bin/wdhwc
  '';

  postFixup = ''
    for bin in $out/bin/*; do
      substituteInPlace $bin \
        --replace-fail 'PYTHONPATH="''${SCRIPT_PATH}/../lib"' "PYTHONPATH=${src}/lib:$PYTHONPATH"
      wrapProgram $bin --prefix PATH : ${lib.makeBinPath [ systemd python3 hddtemp ]}
    done
  '';
}