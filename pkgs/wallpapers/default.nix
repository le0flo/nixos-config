{
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wallpapers";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out
    cp -r ./*.png ./*.jpg $out/.
  '';
})
