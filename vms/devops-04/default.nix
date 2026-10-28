{
  vmConfig = {
    fs.shares = [{
      mountName = "gitolite-projects";
      guestDir = "/app/gitolite/projects";
    }];

    net = {
      address = "10.67.1.4";
      prefixLength = 16;

      gateway = {
        address = "10.67.0.1";
        prefixLength = 16;
      };

      allowedTCPPorts = [
        13001
        13002
        13022
      ];
    };

    services = {
      git = {
        enable = true;
        webPort = 13001;
        sshPort = 13022;
        projectsDir = "/app/gitolite/projects";
        adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENbelRRfee+W2Ba8R4fy5dHXS8F3AzjXP6UOQHNw28P master";
      };
      kanboard = {
        enable = true;
        port = 13002;
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
