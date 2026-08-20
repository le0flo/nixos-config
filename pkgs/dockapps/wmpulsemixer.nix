{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  libxext,
  libxpm,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmpulsemixer";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "polletfa";
    repo = "wmpulsemixer";
    tag = "${finalAttrs.version}";
    hash = "sha256-4cOK/OVc0ZEiDvcmURGhZhkan1NSDr0NqBky/wlgltw=";
  };

  buildInputs = [
    libx11
    libxpm
    libxext
    libpulseaudio
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -m 755 -Dt $out/bin/ wmpulsemixer

    runHook postInstall
  '';

  meta = {
    description = "A simple PulseAudio mixer for WindowMaker";
    homepage = "https://www.dockapps.net/wmpulsemixer";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
