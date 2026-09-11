{config, customLibs, inputs, lib, pkgs, ...}:

let
  inherit (builtins) concatStringsSep;

  inherit (config.nixpkgs.hostPlatform) system;

  inherit (customLibs.cake.hjem)
    configFmt
    configText
    getConfigFiles;

  inherit (customLibs.cake.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    mkIf
    mkMerge
    removeSuffix;

  cfg = config.otis.gui.hyprland;
  configFiles = getConfigFiles ./hyprland ".lua";
  hyprPkgs = inputs.hyprland.packages."${system}";
in {
  options.otis.gui.hyprland = {
    enable = mkBoolOption "Hyprland window manager" false;
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment.systemPackages = cfg.extraPackages;

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      trusted-users = ["root" "@wheel"];
    };

    /*otis.hjem = [{
      xdg.config.files = mkMerge [
        {
          "hypr/hyprland.lua" = configText ''
          ${concatStringsSep "\n" (map (x: "require(\"${removeSuffix ".lua" x}\")") configFiles)}
          '';
        }
        (genAttrs configFiles (file: {
          type = "copy";
          permissions = "644";
          source = ./hyprland/${file};
          target = "hypr/${file}";
        }))
      ];
    }];*/

    programs.hyprland = {
      enable = true;
      package = hyprPkgs.hyprland;
      portalPackage = hyprPkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };

    xdg.portal = {
      config."hyprland".default = [ "gtk" ];
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };
  };
}
