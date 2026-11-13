{
  lib,
  stdenv,
  fetchgit,
  zig_0_17,
}:

let
  zig = zig_0_17;
in stdenv.mkDerivation (finalAttrs: {
  pname = "statusblocks";
  version = "1.0.1";

  src = fetchgit {
    url = "https://codeberg.org/leoflo/statusblocks";
    tag = finalAttrs.version;
    hash = "sha256-eno1GUk2aTx1uKaGXqYPHNWN4/XvQ3CRfjNKS1momAE=";
  };

  nativeBuildInputs = [ zig ];

  zigBuildFlags = [ "-Doptimize=ReleaseSafe" ];

  meta = {
    description = "Minimal resource status fetcher";
    homepage = "https://codeberg.org/leoflo/statusblocks";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
