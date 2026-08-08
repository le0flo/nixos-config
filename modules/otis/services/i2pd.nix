{...}:

{
  services.i2pd = {
    enable = true;

    address = "127.0.0.1";
    port = 4444;

    proto = {
      http.enable = true;
      httpProxy.enable = true;
      socksProxy.enable = true;
      sam.enable = true;
      i2cp.enable = true;
    };
  };
}
