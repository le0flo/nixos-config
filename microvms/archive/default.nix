{lib, microvm, ...}:

let
  inherit (lib) mkForce;

  paperlessPort = 10001;
  paperlessEnvDir = "/etc/paperless";
  paperlessExportDir = "/media/documents";

  immichPort = 10002;
  immichMediaDir = "/media/pictures";
in {
  microvm = {
    mem = mkForce 4096;

    shares = [
      {
        tag = "paperless-environment";
        source = paperlessEnvDir;
        mountPoint = paperlessEnvDir;
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "paperless-exports";
        source = "/mnt/storage/documents";
        mountPoint = paperlessExportDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:315:1000:1"
          "--translate-gid" "map:315:100:1"
        ];
      }
      {
        tag = "pictures";
        source = "/mnt/storage/pictures";
        mountPoint = immichMediaDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:999:1000:1"
          "--translate-gid" "map:999:100:1"
        ];
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    immichPort
    paperlessPort
  ];

  services = {
    immich = {
      enable = true;
      host = "0.0.0.0";
      port = immichPort;

      machine-learning.enable = false;
      mediaLocation = immichMediaDir;
    };

    paperless = {
      enable = true;
      address = "0.0.0.0";
      port = paperlessPort;

      environmentFile = "${paperlessEnvDir}/environment";
      exporter = {
        enable = true;
        directory = paperlessExportDir;
        onCalendar = "07:00:00";
        settings.zip = true;
      };
    };
  };
}
