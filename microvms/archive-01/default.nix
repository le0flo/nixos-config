{
  sirah = {
    cpu = 2;
    memory = 4096;
    disk = 8192;

    shares = [
      {
        host.dir = "/etc/paperless";
        guest.dir = "/etc/paperless";
        readOnly = true;
      }
      {
        host = {
          dir = "/mnt/storage/documents";
          uid = 1000;
          gid = 100;
        };
        guest = {
          dir = "/media/documents";
          uid = 315;
          gid = 315;
        };
        readOnly = false;
      }
      {
        host = {
          dir = "/mnt/storage/pictures";
          uid = 1000;
          gid = 100;
        };
        guest = {
          dir = "/media/pictures";
          uid = 999;
          gid = 999;
        };
        readOnly = false;
      }
    ];

    net.allowedTCPPorts = [
      10001
      10002
    ];

    services = {
      immich = {
        enable = true;
        port = 10002;
        mediaDir = "/media/pictures";
      };
      paperless = {
        enable = true;
        port = 10001;
        envDir = "/etc/paperless";
        exportDir = "/media/documents";
      };
    };
  };
}
