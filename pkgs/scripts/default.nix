{
  fuzzel,
  grim,
  lib,
  slurp,
  stdenvNoCC,
  swaybg,
  writeShellScriptBin,
  withGui ? false,
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

  programsCli = [];
  programsGui = programsCli ++ [
    fuzzel
    grim
    slurp
    swaybg
  ];

  scriptsCli = scripts "cli" programsCli;
  scriptsGui = scripts "gui" programsGui;

  scripts = dir: path: map
    (x: writeShellScriptBin
      (removeSuffix ".sh" x)
      ''
      PATH=${concatMapStringsSep ":" (x: "${toString x}/bin") path}:$PATH
      ${readFile ./${dir}/${x}}
      '')
    (filter (y: hasSuffix ".sh" y) (attrNames (readDir ./${dir})));
in {
  pname = "scripts";
  version = "1.0.0";

  src = ./.;

  buildInputs = if withGui then programsGui else programsCli;

  installPhase = ''
  mkdir -p $out/bin
  ${concatMapStringsSep "\n" (x: "cp ${x}/bin/* $out/bin/") scriptsCli}
  ${if withGui then "${concatMapStringsSep "\n" (x: "cp ${x}/bin/* $out/bin/") scriptsGui}" else ""}
  '';
})
