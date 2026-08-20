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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "addresses";
  version = "0.5.0";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/gap/Addresses-${finalAttrs.version}.tar.gz";
    hash = "sha256-+wdOgMhfSKpX4cAbzc0aV1S63oTWHM99t1Se8gsbpOE=";
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
    description = "Addresses is a versatile Address Book application and framework";
    homepage = "https://www.nongnu.org/gap/addresses/index.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
