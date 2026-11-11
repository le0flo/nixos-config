{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  wayland-scanner,
  zig_0_16,
  fcft,
  kwim,
  libxkbcommon,
  pixman,
  wayland,
  wayland-protocols,
}:

let
  zig = zig_0_16;
in stdenv.mkDerivation (finalAttrs: {
  pname = "kwm";
  version = "0.3.0";

  src = fetchgit {
    url = "https://github.com/kewuaa/kwm";
    rev = "fb7f424e28d685c1cc540a7b0ded6f9ac3e64cd5";
    hash = "sha256-hX76wTHPTgg5RAHILfd3CjRKPlgAwGSK3lG82IFoUUs=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-Lz/Wcy40rxN81n/mBj4YJVbyGOolHzSFZMs93T1h0oQ=";
  };

  postConfigure = ''
  ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    zig
  ];

  buildInputs = [
    fcft
    kwim
    libxkbcommon
    pixman
    wayland
    wayland-protocols
  ];

  zigBuildFlags = [
    "-Doptimize=ReleaseSafe"
    "-Dkwim"
  ];

  meta = {
    description = "Kewuaa's Window Manager";
    homepage = "https://github.com/kewuaa/kwm";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
