{
  stdenv,
  lib,
  fetchurl,
  llvmPackages,
  gnustep-make,
  gnustep-libobjc,
  libblocksruntime,
  gnustep-base,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pantomime";
  version = "1.4.0";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/gnustep-nonfsf/Pantomime-${finalAttrs.version}.tar.gz";
    hash = "sha256-kKWMcbdaZV51z+DbNICyIWOcPr5eCvJ5/W6vspQUOPg=";
  };
  
  nativeBuildInputs = [
    llvmPackages.clang
    
    gnustep-make
    gnustep-libobjc
    libblocksruntime
  ];

  buildInputs = [
    gnustep-base
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
      GNUSTEP_LOCAL_LIBRARY="$out/lib/GNUstep" \
      GNUSTEP_LOCAL_HEADERS="$out/include" \
      GNUSTEP_LOCAL_LIBRARIES="$out/lib" \
      GNUSTEP_LOCAL_DOC="$out/share/GNUstep/Documentation" \
      GNUSTEP_LOCAL_DOC_MAN="$out/share/man" \
      GNUSTEP_LOCAL_DOC_INFO="$out/share/info"

    runHook postInstall
  '';

  meta = {
    description = "Set of Objective-C classes that model a mail system";
    homepage = "https://www.nongnu.org/gnustep-nonfsf/gnumail";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
