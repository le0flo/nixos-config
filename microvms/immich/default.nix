{lib, microvm, pkgs, serviceName, ...}:

let
  inherit (lib) mkForce;

  port = 9002;
  mediaDir = "/media/pictures";
in {
  microvm = {
    forwardPorts = [
      {
        from = "host";
        host = { inherit port; };
        guest = { inherit port; };
      }
    ];

    mem = mkForce 4096;

    shares = [
      {
        tag = "pictures";
        source = "/mnt/storage/pictures";
        mountPoint = mediaDir;

        proto = "virtiofs";
        posixAcl = false;
        extraArgs = [
          "--translate-uid" "map:999:1000:1"
          "--translate-gid" "map:999:100:1"
        ];
      }
    ];

    volumes = [
      {
        image = "${serviceName}-data.img";
        mountPoint = "/var/lib/postgresql";
        size = 4096;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services.immich = {
    inherit port;

    enable = true;
    host = "0.0.0.0";

    machine-learning.enable = false;
    mediaLocation = mediaDir;
  };

  systemd.services."${serviceName}-fs-fix" = {
    wantedBy = [ "multi-user.target" ];
    after = [ "media-pictures.mount" ];
    requires = [ "media-pictures.mount" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/chmod 755 ${mediaDir}";
    };
  };
}
