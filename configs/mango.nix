{lib, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };

  configFiles = builtins.filter
    (x: lib.hasSuffix ".conf" x)
    (builtins.attrNames (builtins.readDir ./mango));

  includeConfigs = lib.join
    "\n"
    (builtins.map
      (x: "source=./${x}")
      configFiles);

  packageConfigs = lib.genAttrs
    configFiles
    (file: {
      type = "copy";
      permissions = "644";

      source = ./mango/${file};
      target = "mango/${file}";
    });

  transformColor = color: "${lib.replaceString "#" "0x" (lib.toUpper color)}FF";
in {
  xdg.config.files = {
    "mango/config.conf" = {
      type = "copy";
      permissions = "644";

      text = ''
        # Sources
        ${includeConfigs}

        # Misc
        no_border_when_single=0
        axis_bind_apply_timeout=100
        focus_on_activate=1
        idleinhibit_ignore_visible=0
        sloppyfocus=1
        warpcursor=1
        focus_cross_monitor=0
        focus_cross_tag=0
        enable_floating_snap=0
        snap_distance=30
        cursor_size=24
        drag_tile_to_tile=1
        drag_tile_small=1

        # Color
        rootcolor=${transformColor style.colors.background}
        focuscolor=${transformColor style.colors.border}
        bordercolor=${transformColor style.colors.background}
        dropcolor=0x8FBA7C55
        splitcolor=0xEB441EFF
        maximizescreencolor=0x89AA61FF
        urgentcolor=0xAD401FFF
        scratchpadcolor=0x516C93FF
        globalcolor=0xB153A7FF
        overlaycolor=0x14A57CFF
        shadowscolor=0x000000FF
      '';
    };
  } // packageConfigs;
}
