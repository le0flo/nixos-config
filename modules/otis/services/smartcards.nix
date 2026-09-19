{config, customLib, lib, pkgs, ...}:

let
  inherit (config.otis) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.smartcards;
in {
  options.otis.services.smartcards.enable = mkBoolOption "Smartcard reader" false;

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pcsc-tools ];
    programs.firefox.nativeMessagingHosts.packages = mkIf gui.enable [ pkgs.web-eid-app ];
    services.pcscd.enable = true;
  };
}
