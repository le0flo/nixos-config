{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.dev;
in {
  imports = [
    ./database.nix
    ./editor.nix
    ./languages.nix
    ./virtualisation.nix
  ];

  options.otis.programs.dev.enable = mkBoolOption "Development" false;

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
      environment.systemPackages = [ pkgs.ungoogled-chromium ];

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
  ]);
}
