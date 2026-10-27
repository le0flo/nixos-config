{config, customLib, lib, pkgs, ...}:

let
  inherit (config.hostConfig) gui;

  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.hostConfig.services.smartcards;
in {
  options.hostConfig.services.smartcards.enable = mkBoolOption "Smartcard reader" false;

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pcsc-tools ];
    programs.firefox.nativeMessagingHosts.packages = mkIf gui.enable [ pkgs.web-eid-app ];
    services.pcscd.enable = true;
  };
}
