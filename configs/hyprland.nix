{lib, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  configFiles = builtins.filter
    (x: lib.hasSuffix ".lua" x)
    (builtins.attrNames (builtins.readDir ./hyprland));

  includeConfigs = lib.join
    "\n"
    (builtins.map
      (x: "require(\"${lib.removeSuffix ".lua" x}\")")
      configFiles);

  packageConfigs = lib.genAttrs
    configFiles
    (file: {
      type = "copy";
      permissions = "644";

      source = ./hyprland/${file};
      target = "hypr/${file}";
    });
in {
  xdg.config.files = {
    "hypr/hyprland.lua" = {
      type = "copy";
      permissions = "644";

      text = ''
        ${includeConfigs}

        hl.config({
          misc = {
            force_default_wallpaper = 0,
            disable_hyprland_logo = true,
          },
        })

        hl.env("XCURSOR_SIZE", "${toString style.cursor.size}")
        hl.env("HYPRCURSOR_SIZE", "${toString style.cursor.size}")
      '';
    };
  }
  // packageConfigs;
}
