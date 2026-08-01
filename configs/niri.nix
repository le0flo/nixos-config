{lib, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  configFiles = builtins.filter
    (x: lib.hasSuffix ".kdl" x)
    (builtins.attrNames (builtins.readDir ./niri));

  includeConfigs = lib.join
    "\n"
    (map
      (x: "include \"${x}\"")
      configFiles);

  packageConfigs = lib.genAttrs
    configFiles
    (file: {
      type = "copy";
      permissions = "644";

      source = ./niri/${file};
      target = "niri/${file}";
    });
in {
  xdg.config.files = {
    "niri/config.kdl" = {
      type = "copy";
      permissions = "644";

      text = ''
        ${includeConfigs}

        layout {
          border {
            active-color "${style.colors.border}"
            inactive-color "${style.colors.background}"
            urgent-color "${style.colors.text}"
          }
        }

        cursor {
          xcursor-theme "${style.cursor.name}"
          xcursor-size ${toString style.cursor.size}

          hide-when-typing
        }
      '';
    };
  }
  // packageConfigs;
}
