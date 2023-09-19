# Until https://github.com/fish-shell/fish-shell/pull/9939 is part of a release
{ fish, fetchpatch }:
fish.overrideAttrs (oldAttrs: {
  postPatch = (oldAttrs.postPatch or "") + ''
    substituteInPlace src/fish_tests.cpp \
      --replace '{TEST_GROUP("history_races"), history_tests_t::test_history_races},' ""
  '';

  patches = (oldAttrs.patches or []) ++ [
    (fetchpatch {
      url = "https://github.com/fish-shell/fish-shell/commit/85504ca694ae099f023ae0febb363238d9c64e8d.diff";
      hash = "sha256-u5MqrS8jRBOIEAGURV6ciXPHidOy6e4tfgsgeyCEOF0=";
    })
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/fish-shell/fish-shell/pull/9939.diff";
      hash = "sha256-4UBghIXpbLkZn/xSBWCoFmo+wtXSiKnR1GakMFBXWvY=";
    })
  ];
})