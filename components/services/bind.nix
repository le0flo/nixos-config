{lib, config, pkgs, ...}: {
  options.bind.enable = lib.mkEnableOption "Bind dns server";

  config = lib.mkIf config.bind.enable {
    services.bind = {
      enable = true;

      forwarders = [ "208.67.222.222" "208.67.220.220" ];

      zones = {
        "home.arpa" = {
          master = true;
          allowQuery = [ "127.0.0.0/24" "10.0.69.0/24" ];
          file = pkgs.writeText "home.arpa" ''
            $TTL 86400
            @ IN SOA ns1.home.arpa. admin.home.arpa. (
              2026031801 ; serial
              3600       ; refresh
              900        ; retry
              604800     ; expire
              86400      ; minimum TTL
            )
            @   IN NS  ns1.home.arpa.
            ns1 IN A   10.69.0.1
            @   IN A   10.69.0.1
          '';
        };
      };
    };
  };
}
