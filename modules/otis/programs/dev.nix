{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.hjem) configFmt;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.dev;
in {
  options.otis.programs.dev = {
    enable = mkBoolOption "Development" false;
    languages = mkBoolOption "Enables language tools" false;
    databases = mkBoolOption "Enables database tools" false;
    virtManager = mkBoolOption "Enables virt-manager" false;
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        shellAliases."k" = "${pkgs.scripts}/bin/kubectl-wrapper";

        systemPackages = with pkgs; [
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
        ungoogled-chromium
        zed-editor
      ];

      otis.hjem = [{
        xdg.config.files."zed/settings.json" = configFmt pkgs.formats.json "settings.json" {
          disable_ai = true;

          ui_font_size = 16;
          buffer_font_size = 16;

          theme = {
            mode = "system";
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
    (mkIf cfg.languages {
      environment.systemPackages = with pkgs; [
        gnumake
        meson
      ] ++ [
        gcc
        jdk25
        python313
        zig
        rustc
        cargo
        lua
      ] ++ [
        tree-sitter
        nil
        nixd
      ];
    })
    (mkIf cfg.databases {
      environment.systemPackages = with pkgs; [
        postgresql
        sqlite
      ];
    })
    (mkIf (gui.enable && cfg.databases) {
      environment.systemPackages = [ pkgs.heidisql ];
    })
    (mkIf (gui.enable && cfg.virtManager) {
      programs.virt-manager.enable = true;

      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };
    })
  ]);
}
