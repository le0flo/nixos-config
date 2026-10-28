{secretsEnc, ...}:

{
  vmConfig = {
    fs.shares = [
      {
        mountName = "qbittorrent-storage";
        guestDir = "/app/qbittorrent/storage";
      }
      {
        mountName = "slskd-storage";
        guestDir = "/app/slskd/storage";
      }
    ];

    net.allowedTCPPorts = [
      12001
      12002
    ];

    secrets = {
      "qbittorrent-password" = {
        file = "${secretsEnc}/qbittorrent/password.age";
        path = "/app/qbittorrent/password";
        mode = "400";
        owner = "qbittorrent";
        group = "qbittorrent";
      };
      "slskd-environment" = {
        file = "${secretsEnc}/slskd/environment.age";
        path = "/app/slskd/environment";
        mode = "400";
        owner = "slskd";
        group = "slskd";
      };
    };

    services = {
      qbittorrent = {
        enable = true;
        port = 12001;
        envDir = "/app/qbittorrent";
        storageDir = "/app/qbittorrent/storage";
      };
      slskd = {
        enable = true;
        port = 12002;
        envDir = "/app/slskd";
        storageDir = "/app/slskd/storage";
      };
    };

    users = {
      "qbittorrent".id = 1001;
      "slskd".id = 1002;
    };
    groups = {
      "qbittorrent".id = 1001;
      "slskd".id = 1002;
    };
  };
}
