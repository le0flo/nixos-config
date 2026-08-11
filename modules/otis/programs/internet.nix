{config, lib, pkgs, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge;

  internet = config.otis.programs.internet;
  gui = config.otis.gui;
in {
  options.otis.programs.internet.enable = mkEnableOption "Add internet related programs";

  config = mkIf internet.enable (mkMerge [
    {
      environment.systemPackages = with pkgs; [
        curl
        wget
        dig
        openssh
        rsync
        wireguard-tools
      ];
    }
    (mkIf gui.enable {
      environment.systemPackages = with pkgs; [
        localsend
        qbittorrent
        nicotine_plus
      ];

      programs = {
        firefox.enable = true;
        thunderbird.enable = true;
      };
    })
  ]);
}
