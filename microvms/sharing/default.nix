{microvm, ...}:

{
  microvm = {
    shares = [];

    forwardPorts = [
      {
        from = "host";
        host.port = 10005;
        guest.port = 10005;
      }
      {
        from = "host";
        host.port = 10006;
        guest.port = 10006;
      }
    ];
  };

  services = {
    qbittorrent = {
      enable = true;
      openFirewall = true;
      
      webuiPort = 10005;
    };

    #slskd = {
    #  enable = true;
    #  openFirewall = true;

    #  settings.web.port = 10006;
    #};
  };
}
