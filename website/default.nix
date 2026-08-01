{
  stdenvNoCC,
}:

let
  domain = (import ../vpn/values.nix {}).publicDomain;
in stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "website";
  version = "1.0.0";
  
  src = ./.;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
    substituteInPlace $out/index.html --replace-fail '*domain*' '${domain}'
  '';
})
