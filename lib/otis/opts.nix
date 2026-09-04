{lib}:

let
  inherit (lib)
    mkOption
    types;
in {
  opts = {
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

    mkPkgOption = description: default: mkOption {
      inherit description default;
      type = types.package;      
    };

    mkPkgsOption = description: default: mkOption {
      inherit description default;
      type = with types; listOf package;      
    };
  };
}
