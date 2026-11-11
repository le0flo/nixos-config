{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  wayland-scanner,
  libevdev,
  libffi,
  libscfg,
  libxkbcommon,
  pixman,
  wayland,
  wayland-protocols,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tarazed";
  version = "0.0.0";

  src = fetchgit {
    url = "https://gitlab.gwdg.de/leonhenrik.plickat/tarazed";
    rev = "0a5ee868510c268c9ad9dc3e9b662db46e01963a";
    hash = "sha256-vzaloGV0st1yDTRujRJo3NSjGNHsqBCZD1/fFB7d9u4=";
  };

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libevdev
    libffi
    libscfg
    libxkbcommon
    pixman
    wayland
    wayland-protocols
  ];

  buildPhase = ''
  runHook preBuild

  make release

  runHook postBuild
  '';

  installPhase = ''
  runHook preInstall

  install -Dm755 -t $out/bin tarazed
  install -Dm644 -t $out/share/licenses/tarazed LICENSE
  install -Dm644 -t $out/share/man/man1 doc/tarazed.1
  install -Dm644 -t $out/share/man/man5 doc/tarazed.5

  runHook postInstall
  '';

  meta = {
    description = "A window manager for the river Wayland server";
    homepage = "https://gitlab.gwdg.de/leonhenrik.plickat/tarazed";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
