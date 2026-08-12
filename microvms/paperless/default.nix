{microvm, ...}:

{
  microvm = {
    shares = [];

    forwardPorts = [
      {
        from = "host";
        host.port = 9003;
        guest.port = 9003;
      }
    ];
  };

  services.paperless = {
    enable = true;

    address = "0.0.0.0";
    port = 9003;
  };
}
