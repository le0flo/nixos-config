{config, lib, ...}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types;
in {
  options.otis.services.tor = {
    enable = mkEnableOption "Tor proxy";

    address = mkOption {
      type = types.str;
      description = "Tor address";
      default = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      description = "Tor port";
      default = 5555;
    };
  };

  config =
    let
      tor = config.otis.services.tor;
    in {
      services.tor = {
        enable = tor.enable;
        enableGeoIP = false;

        client = {
          enable = true;
          dns.enable = true;

          socksListenAddress = {
            IsolateDestAddr = true;
            addr = tor.address;
            port = tor.port;
          };
        };
      };
    };
}
