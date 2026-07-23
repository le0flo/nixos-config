{lib, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  configFiles = builtins.filter
    (x: lib.hasSuffix ".kdl" x)
    (builtins.attrNames (builtins.readDir ./niri));

  includeConfigs = lib.join
    "\n"
    (builtins.map
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

        prefer-no-csd

        hotkey-overlay {
          skip-at-startup
          hide-not-bound
        }

        screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

        layout {
          border {
            active-color "${style.colors.border}"
            inactive-color "${style.colors.background}"
            urgent-color "${style.colors.text}"
          }
        }
      '';
    };
  }
  // packageConfigs;
}
