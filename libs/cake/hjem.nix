{nixpkgs}:

let
  inherit (builtins)
    attrNames
    filter
    readDir;

  inherit (nixpkgs.lib) hasSuffix;
in {
  configDir = {
    type = "directory";
    permissions = "755";
  };

  configFmt = formatter: name: value: {
    inherit value;
    type = "copy";
    permissions = "644";
    generator = (formatter {}).generate name;
  };

  configSource = source: {
    inherit source;
    type = "copy";
    permissions = "644";    
  };

  configText = text: {
    inherit text;
    type = "copy";
    permissions = "644";    
  };

  getConfigFiles = dir: suffix: filter
    (x: hasSuffix suffix x)
    (attrNames (readDir dir));
}
