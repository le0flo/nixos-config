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
  pname = "terminal";
  version = "0.9.9";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/gap/Terminal-${finalAttrs.version}.tar.gz";
    hash = "sha256-J/gbvs29EM3owIABLN5Jc77CDlUcWMKfNTczzwPCIOk=";
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

  postPatch = ''
  substituteInPlace TerminalView.m \
    --replace-fail '<termio.h>' '<termios.h>'

  substituteInPlace TerminalWindow.h \
    --replace-fail \
    'NSString *TerminalWindowNoMoreActiveWindowsNotification;' \
    'extern NSString *TerminalWindowNoMoreActiveWindowsNotification;'
  '';

  meta = {
    description = "A Terminal emulator for GNUstep";
    homepage = "https://www.nongnu.org/gap/terminal/index.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
