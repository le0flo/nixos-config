{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins) concatStringsSep;

  inherit (config.hostConfig.programs) dev;

  inherit (customLib.hjem)
    configFmt
    configText
    getConfigFiles;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge;

  cfg = config.hostConfig.programs.dev.editors;

  emacsFiles = getConfigFiles ./emacs ".el";
in {
  options.hostConfig.programs.dev.editors = {
    emacs = mkBoolOption "GNU Emacs" false;
    octave = mkBoolOption "GNU Octave" false;
    zed = mkBoolOption "Zed editor" false;
  };

  config = mkIf dev.enable (mkMerge [
    (mkIf cfg.emacs {
      environment.systemPackages = with pkgs; [
        ((emacsPackagesFor emacs-gtk).withPackages (epkgs: with epkgs; [
          asciidoc-mode
          auctex
          bnf-mode
          colorful-mode
          corfu
          csv-mode
          dart-mode
          dockerfile-mode
          git-modes
          json-mode
          kirigami
          lua-mode
          magit
          markdown-mode
          matlab-mode
          nginx-mode
          nix-mode
          qml-mode
          rfc-mode
          rust-mode
          sass-mode
          typescript-mode
          vterm
          web-mode
          yaml-mode
          zig-mode
        ]))
      ];

      hostConfig.hjem = [{
        xdg.config.files = mkMerge [
          {
            "emacs/custom.el" = configText "";

            "emacs/init.el" = configText ''
            ;;; -*- lexical-binding: t; -*-

            ;; Includes
            ${concatStringsSep "\n" (map (x: "(load-file \"~/.config/emacs/${x}\")") emacsFiles)}

            ;; Custom file
            (setq custom-file "~/.config/emacs/custom.el")
            (load-file custom-file)
            '';
          }
          (genAttrs emacsFiles (file: {
            type = "copy";
            permissions = "644";
            source = ./emacs/${file};
            target = "emacs/${file}";
          }))
        ];
      }];
    })
    (mkIf cfg.octave {
      environment.systemPackages = [
        ((pkgs.octave.override { enableQt = true; }).withPackages (opkgs: [ opkgs.control ]))
      ];
    })
    (mkIf cfg.zed {
      environment.systemPackages = [ pkgs.zed-editor ];

      hostConfig.hjem = [{
        xdg.config.files."zed/settings.json" = configFmt pkgs.formats.json "settings.json" {
          auto_update = false;
          disable_ai = true;

          telemetry = {
            diagnostics = false;
            metrics = false;
            anthropic_retention = false;
          };

          ui_font_size = 16;
          buffer_font_size = 16;

          theme = {
            mode = "dark";
            light = "Gruvbox Light";
            dark = "Gruvbox Dark";
          };

          agent = {
            button = false;
            favorite_models = [];
            model_parameters = [];
          };
          collaboration_panel = {
            button = false;
          };
          outline_panel = {
            button = false;
          };
          project_panel = {
            dock = "left";
          };
        };
      }];
    })
  ]);
}
