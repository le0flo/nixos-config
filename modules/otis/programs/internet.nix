{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.hjem) configText;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.otis.programs.internet;
in {
  options.otis.programs.internet.enable = mkBoolOption "Internet" false;

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        curl
        wget
        dig
        tcpdump
        nftables
        dhcpcd
        openssh
        rsync
        wireguard-tools
        openssl
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        librewolf
        thunderbird
        dino
        mumble
      ];

      otis.hjem = [{
        xdg.config.files."librewolf/librewolf/librewolf.overrides.cfg" = configText ''
        defaultPref("browser.nova.enabled", false);

        defaultPref("privacy.clearOnShutdown.cookies", false);
        defaultPref("privacy.clearOnShutdown.offlineApps", false);
        defaultPref("privacy.clearOnShutdown_v2.cookiesAndStorage", false);
        defaultPref("privacy.resistFingerprinting", false);
        defaultPref("privacy.sanitize.sanitizeOnShutdown", false);

        defaultPref("webgl.disabled", false);
        '';
      }];

      programs.kdeconnect.enable = true;
    })
  ]);
}
