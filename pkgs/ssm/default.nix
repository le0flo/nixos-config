{
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssm";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
  runHook preInstall

  install -Dm755 -t $out/bin ssm

  runHook postInstall
  '';

  meta = {
    description = "Simple service manager";
    homepage = "https://codeberg.org/leoflo/nixos-config";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
