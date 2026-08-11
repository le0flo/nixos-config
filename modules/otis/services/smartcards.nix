{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf;

  smartcards = config.otis.services.smartcards;
  gui = config.otis.gui;
in {
  options.otis.services.smartcards.enable = mkEnableOption "Smartcard reader";

  config = mkIf smartcards.enable {
    environment.systemPackages = with pkgs; [ pcsc-tools ];

    services.pcscd.enable = true;

    programs.firefox.nativeMessagingHosts.packages = mkIf gui.enable (with pkgs; [ web-eid-app ]);
  };
}
