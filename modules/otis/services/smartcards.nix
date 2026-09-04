{config, customLibs, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.smartcards;
in {
  options.otis.services.smartcards.enable = mkBoolOption "Smartcard reader" false;

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pcsc-tools ];

    programs.firefox.nativeMessagingHosts.packages = mkIf gui.enable (with pkgs; [ web-eid-app ]);

    services.pcscd.enable = true;
  };
}
