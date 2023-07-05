{ fish, fetchpatch }:
fish.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or []) ++ [
    (fetchpatch {
      url = "https://github.com/fish-shell/fish-shell/commit/85504ca694ae099f023ae0febb363238d9c64e8d.diff";
      hash = "sha256-u5MqrS8jRBOIEAGURV6ciXPHidOy6e4tfgsgeyCEOF0=";
    })
  ];
})