{nixpkgs}:

let
  inherit (nixpkgs.lib)
    mkOption
    types;
in {
  mkAttrOption = description: default: mkOption {
    inherit description default;
    type = types.attrs;
  };

  mkAttrSubOption = opts: description: default: mkOption {
    inherit description default;
    type = with types; attrsOf (submodule opts);
  };

  mkBoolOption = description: default: mkOption {
    inherit description default;
    type = types.bool;
  };

  mkEnumOption = values: description: default: mkOption {
    inherit description default;
    type = types.enum values;
  };

  mkIntOption = description: default: mkOption {
    inherit description default;
    type = types.int;
  };

  mkListOption = type: description: default: mkOption {
    inherit description default;
    type = types.listOf type;
  };

  mkListSubOption = opts: description: default: mkOption {
    inherit description default;
    type = with types; listOf (submodule opts);
  };

  mkNullOption = type: description: default: mkOption {
    inherit description default;
    type = types.nullOr type;
  };

  mkPkgOption = description: default: mkOption {
    inherit description default;
    type = types.package;      
  };

  mkPkgsOption = description: default: mkOption {
    inherit description default;
    type = with types; listOf package;      
  };

  mkPortOption = description: default: mkOption {
    inherit description default;
    type = types.port;
  };

  mkStrOption = description: default: mkOption {
    inherit description default;
    type = types.str;
  };

  mkSubOption = opts: description: default: mkOption {
    inherit description default;
    type = types.submodule opts;
  };
}
