{stdenv}:

stdenv.mkDerivation (finalAttrs: {
  pname = "website";
  version = "1.0.0";
  src = ./website;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
})
