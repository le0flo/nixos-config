{pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  packageDataFiles = dataDir: packages: let
    collectFiles = pkg: relPath: let
      path = "${pkg}/share/${dataDir}" + (if relPath == "" then "" else "/${relPath}");
    in
      if !(builtins.pathExists path) then
        []
      else
        builtins.concatLists (
          pkgs.lib.mapAttrsToList (name: type: let
            childRel = if relPath == "" then name else "${relPath}/${name}";
          in
            if type == "directory" then
              collectFiles pkg childRel
            else
              [{
                name = "${dataDir}/${childRel}";
                value.source = "${pkg}/share/${dataDir}/${childRel}";
              }]
            ) (builtins.readDir path)
          );
  in
    builtins.listToAttrs (builtins.concatMap (pkg: collectFiles pkg "") packages);
in {
  xdg.data.files = {
    "fonts" = {
      type = "directory";
      permissions = "755";
    };
  }
  // packageDataFiles "fonts" style.fonts;
}
