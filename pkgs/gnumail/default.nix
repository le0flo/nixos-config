{
  stdenv,
  lib,
  fetchurl,
  llvmPackages,
  gnustep-make,
  gnustep-libobjc,
  libblocksruntime,
  wrapGNUstepAppsHook,
  gnustep-back,
  gnustep-base,
  gnustep-gui,
  pantomime,
  addresses,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnumail";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/gnustep-nonfsf/GNUMail-${finalAttrs.version}.tar.gz";
    hash = "sha256-LZDtkWac28d1BoYPAVffuBcCWLR5tDaUHYFy7HqdzAs=";
  };

  nativeBuildInputs = [
    llvmPackages.clang
    
    gnustep-make
    gnustep-libobjc
    libblocksruntime

    wrapGNUstepAppsHook
  ];

  buildInputs = [
    gnustep-back
    gnustep-base
    gnustep-gui
    
    pantomime
    addresses
    openssl
  ];

  buildPhase = ''
    runHook preBuild

    make \
      CC="clang" \
      CXX="clang++" \
      OBJC="clang" \
      LIBRARY_COMBO="ng-gnu-gnu"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install \
      GNUSTEP_LOCAL_APPS="$out/lib/GNUstep/Applications" \
      GNUSTEP_LOCAL_TOOLS="$out/bin" \
      GNUSTEP_LOCAL_LIBRARY="$out/lib/GNUstep" \
      GNUSTEP_LOCAL_HEADERS="$out/include" \
      GNUSTEP_LOCAL_LIBRARIES="$out/lib" \
      GNUSTEP_LOCAL_DOC="$out/share/GNUstep/Documentation" \
      GNUSTEP_LOCAL_DOC_MAN="$out/share/man" \
      GNUSTEP_LOCAL_DOC_INFO="$out/share/info"

    runHook postInstall
  '';

  meta = {
    description = "Free and open-source, cross-platform e-mail client based on GNUstep";
    homepage = "https://www.nongnu.org/gnustep-nonfsf/gnumail/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
