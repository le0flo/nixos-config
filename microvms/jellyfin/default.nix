{lib, microvm, serviceName, ...}:

let
  inherit (lib) mkForce;

  port = 11002;
  dataDir = "/var/lib/jellyfin";
in {
  microvm = {
    forwardPorts = [
      {
        from = "host";
        host = { inherit port; };
        guest.port = 8096;
      }
    ];

    mem = mkForce 4096;

    shares = [
      {
        tag = "movies";
        source = "/mnt/storage/movies";
        mountPoint = "/media/movies";
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "shows";
        source = "/mnt/storage/shows";
        mountPoint = "/media/shows";
        readOnly = true;

        proto = "virtiofs";
      }
    ];

    volumes = [
      {
        image = "${serviceName}-data.img";
        mountPoint = "/var/lib/jellyfin";
        size = 4096;
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ port ];

  services.jellyfin = {
    inherit dataDir;

    enable = true;
    openFirewall = true;

    configDir = "${dataDir}/config";
    cacheDir = "${dataDir}/cache";
    logDir = "${dataDir}/log";
  };
}
