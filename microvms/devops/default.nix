{config, lib, microvm, pkgs, ...}:

let
  inherit (config.users) groups users;

  inherit (lib) mkForce;

  cgitPort = 13001;
  registryPort = 13002;
  sshPort = 13022;

  codeDir = "/media/code";
  containersDir = "/media/containers";
in {
  microvm = {
    shares = [
      {
        tag = "code";
        source = "/mnt/storage/code";
        mountPoint = codeDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:${toString users."git".uid}:1000:1"
          "--translate-gid" "map:${toString groups."git".gid}:100:1"
        ];
      }
      {
        tag = "containers";
        source = "/mnt/storage/containers";
        mountPoint = containersDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:${toString users."docker-registry".uid}:1000:1"
          "--translate-gid" "map:${toString groups."docker-registry".gid}:100:1"
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    cgitPort
    registryPort
    sshPort
  ];

  services = {
    cgit."home" = {
      enable = true;
      scanPath = config.services.gitolite.dataDir;
      gitHttpBackend.enable = false;
      settings = {
        enable-follow-links = true;
        source-filter = "${pkgs.cgit}/lib/cgit/filters/syntax-highlighting.py";
      };
      nginx.virtualHost = "_";
    };

    dockerRegistry = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = registryPort;
      enableGarbageCollect = true;
      storagePath = containersDir;
    };

    gitolite = {
      enable = true;
      adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIENbelRRfee+W2Ba8R4fy5dHXS8F3AzjXP6UOQHNw28P master";
      dataDir = codeDir;
      group = "git";
      user = "git";
    };

    nginx.virtualHosts."_".listen = [{
      addr = "0.0.0.0";
      port = cgitPort;
    }];

    openssh = {
      enable = true;
      ports = [ sshPort ];
      extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PasswordAuthentication no
        KbdInteractiveAuthentication no
        PermitTTY no
        X11Forwarding no
      '';
    };
  };

  users = {
    users = {
      "git" = {
        uid = mkForce 420;
        isSystemUser = true;
        createHome = true;
        group = "git";
      };
      "docker-registry".uid = 421;
    };
    groups = {
      "git".gid = mkForce 420;
      "docker-registry".gid = 421;
    };
  };
}
