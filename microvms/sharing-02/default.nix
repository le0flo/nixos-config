{
  sirah = {
    cpu = 1;
    memory = 1024;
    disk = 8192;

    shares = [
      {
        host.dir = "/etc/qbittorrent";
        guest.dir = "/etc/qbittorrent";
        readOnly = true;
      }
      {
        host = {
          dir = "/mnt/storage/downloads/bt";
          uid = 1000;
          gid = 100;
        };
        guest = {
          dir = "/media/bt";
          uid = 998;
          gid = 998;
        };
        readOnly = false;
      }
      {
        host.dir = "/etc/slskd";
        guest.dir = "/etc/slskd";
        readOnly = true;
      }
      {
        host = {
          dir = "/mnt/storage/downloads/slsk";
          uid = 1000;
          gid = 100;
        };
        guest = {
          dir = "/media/slsk";
          uid = 997;
          gid = 997;
        };
        readOnly = false;
      }
    ];

    net.allowedTCPPorts = [
      12001
      12002
    ];

    services = {
      qbittorrent = {
        enable = true;
        port = 12001;
        envDir = "/etc/qbittorrent";
        storageDir = "/media/bt";
      };
      slskd = {
        enable = true;
        port = 12002;
        envDir = "/etc/slskd";
        storageDir = "/media/slsk";
      };
    };
  };
}
