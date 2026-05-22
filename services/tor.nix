{...}:

{
  services.tor = {
    enable = true;
    enableGeoIP = false;

    client = {
      enable = true;
      dns.enable = true;

      socksListenAddress = {
        IsolateDestAddr = true;
        addr = "127.0.0.1";
        port = 9050;
      };
    };
  };
}
