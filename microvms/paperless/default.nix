{microvm, pkgs, serviceName, ...}:

let
  port = 9003;
  secretsDir = "/run/secrets/paperless";
  exportDir = "/media/documents";  
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
        tag = "secret";
        source = "/run/agenix/microvms/paperless";
        mountPoint = secretsDir;
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "documents";
        source = "/mnt/storage/documents";
        mountPoint = exportDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "host:1000:315:1"
          "--translate-gid" "host:100:315:1"
        ];
      }
    ];

    volumes = [
      {
        image = "${serviceName}-data.img";
        mountPoint = "/var/lib/paperless";
        size = 4096;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services.paperless = {
    inherit port;

    enable = true;
    address = "0.0.0.0";
    passwordFile = "${secretsDir}/admin-pass";

    exporter = {
      enable = true;
      directory = exportDir;
      onCalendar = "07:00:00";
      settings.zip = true;
    };
  };

  systemd.services."${serviceName}-fs-fix" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "media-documents.mount" ];
    requires = [ "media-documents.mount" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/chmod 755 ${exportDir}";
    };
  };
}
