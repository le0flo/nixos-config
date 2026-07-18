{
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "website";
  version = "1.0.0";
  
  src = ./.;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
  '';
})
