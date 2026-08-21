{
  stdenvNoCC,
  domain ? "example.com",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "www-public";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out
    cp -r ./*.html ./*.css ./*.gif $out/.
    substituteInPlace $out/index.html --replace-fail '*domain*' '${domain}'
  '';
})
