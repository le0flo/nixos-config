{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf;
in {
  options.otis.services.smartcards.enable = mkEnableOption "Smartcard reader";
  config =
    let
      smartcards = config.otis.services.smartcards;
      gui = config.otis.gui;
    in mkIf smartcards.enable {
      environment.systemPackages = with pkgs; [ pcsc-tools ];
  
      services.pcscd.enable = true;

      programs.firefox.nativeMessagingHosts.packages = mkIf gui.enable (with pkgs; [ web-eid-app ]);
    };
}
