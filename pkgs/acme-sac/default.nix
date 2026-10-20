{
  fetchzip,
  stdenv,
  lib,
  libx11,
  libxext,
  tree,
}:

stdenv.mkDerivation(finalAttrs: {
  pname = "acme-sac";
  version = "0.0.0";

  src = fetchzip {
    url = "https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/acme-sac/source-archive.zip";
    hash = "sha256-phWBfMFOv28I30jvDIjJ5lhuvIbt5Ajv2rVldBfaJxg=";
  };

  nativeBuildInputs = [ tree ];

  buildInputs = [
    libx11
    libxext
  ];

  buildPhase = ''
  runHook preBuild

  cp -r "$src/." .
  chmod -R u+w .

  # Make GNU extensions visible to the legacy Linux code.
  substituteInPlace sys/Linux/cmd/9c \
    --replace-fail 'gcc -O2' 'gcc -D_GNU_SOURCE -fcommon -O2'

  # dev.c uses time().
  sed -i '1i #include <time.h>' sys/emu/port/dev.c

  # pthread_yield() has been replaced by sched_yield().
  sed -i '1i #include <sched.h>' sys/emu/port/kproc-pthreads.c
  substituteInPlace sys/emu/port/kproc-pthreads.c \
    --replace-fail 'pthread_yield()' 'sched_yield()'

  # Declare wmtrack() before its use in the Linux X11 implementation.
  sed -i '1i extern void wmtrack(int, int, int, int);' \
    sys/emu/port/win-x11a.c

  # Declare nrand(), whose implementation is in devcons.c.
  sed -i '1i extern int nrand(int);' sys/emu/port/devssl.c

  # Avoid conflicting with glibc's memrchr() declaration.
  substituteInPlace sys/emu/port/chan.c \
    --replace-fail 'memrchr(void *va, int c, long n)' \
                   'acme_memrchr(void *va, int c, long n)'

  cd sys
  ./build.sh
  cd ..

  runHook postBuild
  '';

  installPhase = ''
  runHook preInstall

  install -m755 -D sys/emu/Linux/o.emu $out/bin/emu

  mkdir -p $out/share/src/acme-sac
  cp -r $src/* $out/share/src/acme-sac/.

  runHook postInstall
  '';

  meta = {
    description = "Acme is a programmer's text editor, shell, and user interface";
    homepage = "https://code.google.com/archive/p/acme-sac/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
