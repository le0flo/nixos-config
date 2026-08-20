{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  libx11,
  libxext,
  libxpm,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmclockmon";
  version = "1.0.0";

  src = fetchurl {
    url = "https://www.dockapps.net/download/wmclockmon-${finalAttrs.version}.tar.xz";
    hash = "sha256-FFkKb+UVntG56Ei9VN2/mgSDpnJ7nmiaPl7Thdqhf98=";
  };

  nativeBuildInputs = [ pkg-config ];
  
  buildInputs = [
    libx11
    libxpm
    libxext
    gtk3
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -m 755 -Dt $out/bin/ src/wmclockmon

    runHook postInstall
  '';

  meta = {
    description = "A nice digital clock with 7 different styles either in LCD style and LED style";
    homepage = "https://www.dockapps.net/wmclockmon";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
