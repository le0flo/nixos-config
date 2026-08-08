{lib, pkgs, ...}:

let
  scriptFiles = builtins.filter
    (x: lib.hasSuffix ".sh" x)
    (builtins.attrNames (builtins.readDir ./scripts));

  packageScripts = lib.genAttrs
    scriptFiles
    (file: {
      type = "copy";
      permissions = "755";
      
      source = ./scripts/${file};
      target = "scripts/${file}";
    });  
in {
  xdg.config.files = packageScripts;
}
