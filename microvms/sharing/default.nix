{microvm, serviceName, ...}:

let
  btPort = 12001;
  btDownloadDir = "/media/bt";

  slskPort = 12002;
  slskEnvDir = "/run/secrets/slsk";
  slskDownloadDir = "/media/slsk";
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

    shares = [
      {
        tag = "soulseek-secrets";
        source = "/etc/slskd";
        mountPoint = slskEnvDir;
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "bittorrent-downloads";
        source = "/mnt/storage/downloads/bt";
        mountPoint = btDownloadDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:998:1000:1"
          "--translate-gid" "map:998:100:1"
        ];
      }
      {
        tag = "soulseek-downloads";
        source = "/mnt/storage/downloads/slsk";
        mountPoint = slskDownloadDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:997:1000:1"
          "--translate-gid" "map:997:100:1"
        ];
      }
    ];

    volumes = [
      {
        image = "${serviceName}-data.img";
        mountPoint = "/var/lib";
        size = 4096;
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
      serverConfig = {
        LegalNotice.Accepted = true;
        Preferences = {
          Downloads = {
            SavePath = "${btDownloadDir}/complete";
            TempPath = "${btDownloadDir}/incomplete";
          };
          WebUI = {
            CSRFProtection = false;
            HostHeaderValidation = false;

            ReverseProxySupportEnabled = true;
            TrustedReverseProxiesList = "10.69.0.1";

            AuthSubnetWhitelistEnabled = true;
            AuthSubnetWhitelist = "10.69.0.0/24";
          };
        };
      };
    };

    slskd = {
      enable = true;

      environmentFile = "${slskEnvDir}/environment";
      settings = {
        directories = {
          downloads = "${slskDownloadDir}/complete";
          incomplete = "${slskDownloadDir}/incomplete";
        };
        web.port = slskPort;
      };
    };
  };
}
