{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins) concatStringsSep;

  inherit (config.otis) gui;

  inherit (customLib.hjem)
    configText
    getConfigFiles;

  inherit (customLib.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    genAttrs
    mkIf
    mkMerge;

  cfg = config.otis.programs.dev;
  configFiles = getConfigFiles ./emacs ".el";
in {
  options.otis.programs.dev = {
    enable = mkBoolOption "Add development programs" false;
    virt-manager = mkBoolOption "Enables virt-manager" false;
    extraEmacsPlugins = mkPkgsOption "List of emacs plugins" [];
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        shellAliases."k" = "${pkgs.scripts}/bin/kubectl-wrapper";

        systemPackages = with pkgs; [
          gnumake
          postgresql
          sqlite
          openssl
          kubectl
          kubernetes-helm
          scripts
        ];
      };

      programs.git = {
        enable = true;

        config = {
          core.editor = "nano";
          init.defaultBranch = "master";
        };
      };
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        tree-sitter
        ungoogled-chromium
        heidisql
        ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: with epkgs; [
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
          rfc-mode
          rust-mode
          sass-mode
          typescript-mode
          web-mode
          yaml-mode
          zig-mode
        ]
        ++ cfg.extraEmacsPlugins))
      ];

      otis.hjem = [{
        xdg.config.files = mkMerge [
          {
            "emacs/custom.el" = configText "";
            "emacs/init.el" = configText ''
            ;;; -*- lexical-binding: t; -*-

            ;; Includes
            ${concatStringsSep "\n" (map (x: "(load-file \"~/.config/emacs/${x}\")") configFiles)}

            ;; Custom file
            (setq custom-file "~/.config/emacs/custom.el")
            (load-file custom-file)
            '';
          }
          (genAttrs configFiles (file: {
            type = "copy";
            permissions = "644";
            source = ./emacs/${file};
            target = "emacs/${file}";
          }))
        ];
      }];

      programs.chromium = {
        enable = true;
        defaultSearchProviderEnabled = true;
        defaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
        extraOpts = {
          "ClearBrowsingDataOnExitList" = [
            "autofill"
            "browsing_history"
            "cached_images_and_files"
            "cookies_and_other_site_data"
            "download_history"
            "hosted_app_data"
            "password_signin"
            "site_settings"
          ];

          "SearchSuggestEnabled" = false;
        };
      };
    })
    (mkIf (gui.enable && cfg.virt-manager) {
      programs.virt-manager.enable = true;

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    })
  ]);
}
