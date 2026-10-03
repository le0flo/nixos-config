{
  sirah = {
    cpu = 1;
    memory = 1024;
    disk = 8192;

    shares = [
      {
        host = {
          dir = "/mnt/storage/projects";
          uid = 1000;
          gid = 100;
        };
        guest = {
          dir = "/media/projects";
          uid = 1001;
          gid = 1001;
        };
        readOnly = false;
      }
      {
        host = {
          dir = "/mnt/storage/tasks";
          uid = 1000;
          gid = 100;
        };
        guest = {
          dir = "/media/tasks";
          uid = 1002;
          gid = 1002;
        };
        readOnly = false;
      }
    ];

    net.allowedTCPPorts = [
      13001
      13002
      13022
    ];

    services = {
      git = {
        enable = true;
        webPort = 13001;
        sshPort = 13022;
        projectsDir = "/media/projects";
        adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENbelRRfee+W2Ba8R4fy5dHXS8F3AzjXP6UOQHNw28P master";
      };
      kanboard = {
        enable = true;
        port = 13002;
        dataDir = "/media/tasks";
      };
    };

    users = {
      "git".id = 1001;
      "kanboard".id = 1002;
    };
    groups = {
      "git".id = 1001;
      "kanboard".id = 1002;
    };
  };
}
