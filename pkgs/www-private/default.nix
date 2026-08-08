{
  config,
  inputs,
  lib,
  stdenvNoCC,
}:

let
  domain = (import ../../vpn/values.nix { inherit config inputs lib; }).privateDomain;
in stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "www-private";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out
    cp -r ./* $out/
    substituteInPlace $out/index.html --replace-fail '*domain*' '${domain}'
  '';
})
