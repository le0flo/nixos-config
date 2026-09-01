{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  internet = config.otis.programs.internet;
  gui = config.otis.gui;

  mkBookmark = name: url: {
    Title = name;
    URL = url;
    Placement = "toolbar";
  };

  mkExtension = short: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
    installation_mode = "force_installed";
    updates_disabled = true;
    private_browsing = true;
    default_area = "navbar";
  };
in {
  options.otis.programs.internet.enable = mkEnableOption "Add internet related programs";

  config = mkIf internet.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        curl
        wget
        dig
        tcpdump
        nftables
        openssh
        rsync
        wireguard-tools
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        qbittorrent
        nicotine-plus
      ];

      programs = {
        firefox = {
          enable = true;

          policies = {
            AppAutoUpdate = false;
            BackgroundAppUpdate = false;

            DisableFirefoxAccounts = true;
            DisableFirefoxScreenshot = true;
            DisableFirefoxStudies = true;
            DisableForgetButton = true;
            DisableFormHistory = true;
            DisableMasterPasswordCreation = true;
            DisablePasswordReveal = true;
            DisablePocket = true;
            DisableProfileImport = true;
            DisableProfileRefresh = true;
            DisableSetDesktopBackground = true;
            DisableTelemetry = true;

            AIControls.Default = "blocked";
            DefaultDownloadDirectory = "~/Downloads";
            DisplayMenuBar = "never";
            DontCheckDefaultBrowser = true;
            GenerativeAI.Enabled = false;
            HardwareAcceleration = true;
            OfferToSaveLogins = false;
            PostQuantumKeyAgreementEnabled = true;
            SearchEngines.Default = "duckduckgo";
            SearchSuggestEnabled = false;
            ShowHomeButton = true;

            Bookmarks = [
              (mkBookmark "Codeberg" "https://codeberg.org/")
              (mkBookmark "Github" "https://github.com/")
              (mkBookmark "Cloudflare" "https://dash.cloudflare.com/")
              (mkBookmark "Contabo" "https://new.contabo.com/")
              (mkBookmark "Studenti Online" "https://studenti.unibo.it/")
              (mkBookmark "Virtuale" "https://virtuale.unibo.it/")
              (mkBookmark "Whatsapp" "https://web.whatsapp.com/") 
              (mkBookmark "Telegram" "https://web.telegram.org/a/")
              (mkBookmark "Youtube" "https://youtube.com/")
              (mkBookmark "Soundcloud" "https://soundcloud.com/")
            ];

            FirefoxHome = {
              Search = true;
              TopSites = false;
              SponsoredTopSites = false;
              Highlights = false;
              Pocket = false;
              Stories = false;
              SponsoredPocket = false;
              SponsoredStories = false;
              Snippets = false;
            };

            FirefoxSuggest = {
              WebSuggestions = false;
              SponsoredSuggestions = false;
              ImproveSuggest = false;
            };

            ExtensionSettings = {
              "*".installation_mode = "allowed";

              "uBlock0@raymondhill.net" = mkExtension "ublock-origin";
              "keepassxc-browser@keepassxc.org" = mkExtension "keepassxc-browser";
              "DontFuckWithPaste@raim.ist" = mkExtension "don-t-fuck-with-paste";
              "addon@darkreader.org" = mkExtension "darkreader";
            };
          };

          preferences = {
            "browser.policies.runOncePerModification.setDefaultSearchEngine" = "duckduckgo";
            "browser.tabs.inTitlebar" = 0;
            "sidebar.history.sortOption" = "date";
          };
        };
        thunderbird.enable = true;
        localsend.enable = true;
      };
    })
  ]);
}
