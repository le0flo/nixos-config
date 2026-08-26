{microvm, ...}:

let
  btPort = 10005;
  slskPort = 10006;
in {
  microvm = {
    forwardPorts = [
      {
        from = "host";
        host.port = btPort;
        guest.port = btPort;
      }
      {
        from = "host";
        host.port = slskPort;
        guest.port = slskPort;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    btPort
    slskPort
  ];

  services = {
    qbittorrent = {
      enable = true;

      webuiPort = btPort;
    };

    /*slskd = {
      enable = true;
    
      settings.web.port = slskPort;
    };*/
  };
}
