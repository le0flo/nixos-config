{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.fail2ban;
in {
  options.otis.services.fail2ban.enable = mkBoolOption "fail2ban anti spam filter" false;

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      extraPackages = [ pkgs.ipset ];

      maxretry = 5;
      ignoreIP = [
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
      ];

      bantime = "24h";
      bantime-increment = {
        enable = true;
        overalljails = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
      };
    };
  };
}
