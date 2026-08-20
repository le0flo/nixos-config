{
  stdenv,
  lib,
  fetchurl,
  libx11,
  libxext,
  libxpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmnd";
  version = "0.4.18";

  src = fetchurl {
    url = "https://www.thregr.org/wavexx/software/wmnd/releases/wmnd-${finalAttrs.version}.tar.gz";
    hash = "sha256-Fjyv9v6W0UofdHFI9XZgeXGWSVYjcFqD+sxex1A7Qwc=";
  };

  buildInputs = [
    libx11
    libxpm
    libxext
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -m 755 -Dt $out/bin/ src/wmnd

    runHook postInstall
  '';

  meta = {
    description = "Dockapp for monitoring network interfaces";
    homepage = "https://www.dockapps.net/wmnd";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
