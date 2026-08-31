{
  stdenvNoCC,
  privateDomain ? "example.com",
  publicDomain ? "example.com"
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "www-private";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out
    cp -r ./*.html ./*.css ./*.gif $out/.
    substituteInPlace $out/index.html --replace-fail '*privateDomain*' '${privateDomain}'
    substituteInPlace $out/index.html --replace-fail '*publicDomain*' '${publicDomain}'
  '';
})
