{config, lib, microvm, pkgs, ...}:

let
  inherit (lib)
    mkAfter
    mkForce;

  navidromePort = 11001;
  navidromeMusicDir = "/media/music";

  jellyfinPort = 11002;
  jellyfinDataDir = "/var/lib/jellyfin";
in {
  microvm = {
    mem = mkForce 4096;

    shares = [
      {
        tag = "jellyfin-movies";
        source = "/mnt/storage/movies";
        mountPoint = "/media/movies";
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "jellyfin-shows";
        source = "/mnt/storage/shows";
        mountPoint = "/media/shows";
        readOnly = true;

        proto = "virtiofs";
      }
      {
        tag = "navidrome-music";
        source = "/mnt/storage/music";
        mountPoint = navidromeMusicDir;
        readOnly = true;

        proto = "virtiofs";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [
    jellyfinPort
    navidromePort
  ];

  services = {
    jellyfin = {
      enable = true;

      dataDir = jellyfinDataDir;
      configDir = "${jellyfinDataDir}/config";
      cacheDir = "${jellyfinDataDir}/cache";
      logDir = "${jellyfinDataDir}/log";
    };

    navidrome = {
      enable = true;

      settings = {
        Address = "0.0.0.0";
        Port = navidromePort;
      };
    };
  };

  systemd.services = {
    "jellyfin-init" = {
      wantedBy = [ "jellyfin.service" ];
      before = [ "jellyfin.service" ];

      serviceConfig.Type = "oneshot";

      script = let
        inherit (config.services.jellyfin) group user;
      in ''
      mkdir -p ${jellyfinDataDir}/config
      if [ -e ${jellyfinDataDir}/config/network.xml ]; then
        exit 0
      fi

      cat > ${jellyfinDataDir}/config/network.xml <<'EOF'
      <?xml version="1.0" encoding="utf-8"?>
      <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <BaseUrl />
        <EnableHttps>false</EnableHttps>
        <RequireHttps>false</RequireHttps>
        <CertificatePath />
        <CertificatePassword />

        <InternalHttpPort>${toString jellyfinPort}</InternalHttpPort>
        <InternalHttpsPort>8920</InternalHttpsPort>
        <PublicHttpPort>${toString jellyfinPort}</PublicHttpPort>
        <PublicHttpsPort>8920</PublicHttpsPort>

        <AutoDiscovery>true</AutoDiscovery>
        <EnableUPnP>false</EnableUPnP>
        <EnableIPv4>true</EnableIPv4>
        <EnableIPv6>false</EnableIPv6>
        <EnableRemoteAccess>true</EnableRemoteAccess>

        <LocalNetworkSubnets />
        <LocalNetworkAddresses />
        <KnownProxies />
      </NetworkConfiguration>
      EOF

      chown -R ${user}:${group} ${jellyfinDataDir}/config
      fi
      '';
    };
    "navidrome".serviceConfig.BindReadOnlyPaths = [ navidromeMusicDir ];
  };
}
