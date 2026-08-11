{
  lib,
  stdenvNoCC,
  writeShellScriptBin,
}:

stdenvNoCC.mkDerivation (finalAttrs: let
  inherit (builtins)
    attrNames
    filter
    readDir
    readFile;

  inherit (lib)
    concatMapStringsSep
    hasSuffix
    removeSuffix;

  scripts = map
    (x: writeShellScriptBin (removeSuffix ".sh" x) (readFile ./${x}))
    (filter (y: hasSuffix ".sh" y) (attrNames (readDir ./.)));
in {
  pname = "scripts";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    ${concatMapStringsSep "\n" (x: "cp ${x}/bin/* $out/bin/") scripts}
  '';
})
