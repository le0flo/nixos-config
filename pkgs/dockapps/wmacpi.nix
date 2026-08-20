{
  stdenv,
  lib,
  dockapps-sources,
  libx11,
  libxext,
  libxpm,
  dockapps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wmacpi";

  inherit (dockapps-sources) version src;

  sourceRoot = "${finalAttrs.src.name}/wmacpi";
  
  buildInputs = [
    libx11
    libxpm
    libxext
    dockapps.libdockapp
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    install -m 755 -Dt $out/bin/ wmacpi

    runHook postInstall
  '';

  meta = {
    description = "Battery/Power status monitor for laptops";
    homepage = "https://www.dockapps.net/wmacpi";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
