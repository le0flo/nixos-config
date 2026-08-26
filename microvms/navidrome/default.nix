{lib, microvm, serviceName, ...}:

let
  port = 9001;
  musicDir = "/media/music";
in {
  microvm = {
    forwardPorts = [
      {
        from = "host";
        host = { inherit port; };
        guest = { inherit port; };
      }
    ];

    shares = [
      {
        tag = "music";
        source = "/mnt/storage/music";
        mountPoint = musicDir;
        readOnly = true;

        proto = "virtiofs";
      }
    ];

    volumes = [
      {
        image = "${serviceName}-data.img";
        mountPoint = "/var/lib/navidrome";
        size = 4096;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services.navidrome = {
    enable = true;

    settings = {
      Address = "0.0.0.0";
      Port = port;
      MusicFolder = musicDir;
    };
  };
}
