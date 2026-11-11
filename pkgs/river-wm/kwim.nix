{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  wayland-scanner,
  zig_0_16,
  libxkbcommon,
  wayland,
  wayland-protocols,
}:

let
  zig = zig_0_16;
in stdenv.mkDerivation (finalAttrs: {
  pname = "kwim";
  version = "0.2.0";

  src = fetchgit {
    url = "https://github.com/kewuaa/kwim";
    rev = "0a912e4418d162621544409944aeb43b960a03b4";
    hash = "sha256-ewg259zRCMGq75XXMmPqoFwD5NBEFXXsIj1rvMy31uw=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-rOZZu/Y/rZ7who3hl1qIBHXZtRP7s4FXo0+LNnM6dYo=";
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
    libxkbcommon
    wayland
    wayland-protocols
  ];

  zigBuildFlags = [ "-Doptimize=ReleaseSafe" ];

  meta = {
    description = "kewuaa's input manager for River Wayland compositor";
    homepage = "https://github.com/kewuaa/kwim";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
