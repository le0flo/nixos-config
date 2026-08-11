{
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wallpapers";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/share/wallpapers
    cp -r ./*.png ./*.jpg $out/share/wallpapers/.
  '';
})
