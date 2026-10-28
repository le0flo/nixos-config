{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.hjem) configText;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib)
    mkIf
    mkMerge;

  cfg = config.hostConfig.programs.internet;
in {
  options.hostConfig.programs.internet.enable = mkBoolOption "Internet" false;

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
        mumble
      ];

      hostConfig.hjem = [{
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

      programs = {
        kdeconnect.enable = true;
        ssh.askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
      };
    })
  ]);
}
