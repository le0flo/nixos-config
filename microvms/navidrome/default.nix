{microvm, ...}:

{
  microvm = {
    shares = [
      {
        tag = "music";
        source = "/mnt/storage/music";
        mountPoint = "/var/lib/navidrome/libraries";
        readOnly = true;
      }
    ];

    volumes = [
      {
        image = "navidrome-data.img";
        mountPoint = "/var/lib/navidrome";
        size = 2048;
      }
    ];

    forwardPorts = [
      {
        from = "host";
        host.port = 9001;
        guest.port = 9001;
      }
    ];
  };

  services.navidrome = {
    enable = true;
    openFirewall = true;

    settings = {
      Address = "0.0.0.0";
      Port = 9001;
    };
  };
}
