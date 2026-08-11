{config, lib, ...}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types;

  i2pd = config.otis.services.i2pd;
in {
  options.otis.services.i2pd = {
    enable = mkEnableOption "I2Pd proxy";

    address = mkOption {
      type = types.str;
      description = "I2Pd address";
      default = "127.0.0.1";
    };

    port = mkOption {
      type = types.port;
      description = "I2Pd port";
      default = 4444;
    };
  };

  config = {
    services.i2pd = {
      inherit (i2pd) enable address port;

      proto = {
        http.enable = true;
        httpProxy.enable = true;
        socksProxy.enable = true;
        sam.enable = true;
        i2cp.enable = true;
      };
    };
  };
}
