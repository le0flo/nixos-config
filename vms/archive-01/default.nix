{secretsEnc, ...}:

{
  vmConfig = {
    fs.shares = [
      {
        mountName = "paperless-export";
        guestDir = "/app/paperless/export";
      }
      {
        mountName = "immich-media";
        guestDir = "/app/immich/media";
      }
      {
        mountName = "immich-old-pictures";
        guestDir = "/app/immich/old-pictures";
      }
    ];

    net = {
      address = "10.67.1.1";
      prefixLength = 16;

      gateway = {
        address = "10.67.0.1";
        prefixLength = 16;
      };

      allowedTCPPorts = [
        10001
        10002
      ];
    };

    secrets = {
      "paperless-environment" = {
        file = "${secretsEnc}/paperless/environment.age";
        path = "/app/paperless/environment";
        mode = "400";
        owner = "paperless";
        group = "paperless";
      };
    };

    services = {
      immich = {
        enable = true;
        port = 10002;
        mediaDir = "/app/immich/media";
      };
      paperless = {
        enable = true;
        port = 10001;
        envDir = "/app/paperless";
        exportDir = "/app/paperless/export";
      };
    };

    users = {
      "immich".id = 1001;
      "paperless".id = 1002;
    };
    groups = {
      "immich".id = 1001;
      "paperless".id = 1002;
    };
  };
}
