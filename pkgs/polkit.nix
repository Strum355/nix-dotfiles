{ polkit, fetchpatch }:
# https://github.com/NixOS/nixpkgs/issues/18012#issuecomment-962206634
polkit.overrideAttrs (oldAttrs: {
  patches = (oldAttrs.patches or [ ]) ++ [
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/polkit/polkit/-/commit/716a273ce0af467968057f3e107156182bd290b0.patch";
      sha256 = "sha256-hOJJhUmxXm87W1ZU9Y1NJ8GCyKvPjbIVtCHlhRGlN8k=";
    })
  ];
})
