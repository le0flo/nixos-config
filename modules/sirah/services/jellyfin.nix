{config, customLib, ...}:

let
  inherit (config.services.jellyfin) dataDir group user;

  inherit (customLib.opts)
    mkBoolOption
    mkPortOption;

  cfg = config.sirah.services.jellyfin;
in {
  options.sirah.services.jellyfin = {
    enable = mkBoolOption "Enable the Jellyfin media server" false;
    port = mkPortOption "Port of the Jellyfin server" 11002;
  };
  
  config = {
    services.jellyfin = {
      inherit (cfg) enable;

      dataDir = "/var/lib/jellyfin";
      configDir = "${dataDir}/config";
      cacheDir = "${dataDir}/cache";
      logDir = "${dataDir}/log";
    };

    systemd.services."jellyfin-init" = {
      wantedBy = [ "jellyfin.service" ];
      before = [ "jellyfin.service" ];

      serviceConfig.Type = "oneshot";

      script = ''
      mkdir -p ${dataDir}/config
      if [ -e ${dataDir}/config/network.xml ]; then
        exit 0
      fi

      cat > ${dataDir}/config/network.xml <<'EOF'
      <?xml version="1.0" encoding="utf-8"?>
      <NetworkConfiguration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
        <BaseUrl />
        <EnableHttps>false</EnableHttps>
        <RequireHttps>false</RequireHttps>
        <CertificatePath />
        <CertificatePassword />

        <InternalHttpPort>${toString cfg.port}</InternalHttpPort>
        <InternalHttpsPort>8920</InternalHttpsPort>
        <PublicHttpPort>${toString cfg.port}</PublicHttpPort>
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

      chown -R ${user}:${group} ${dataDir}/config
      '';
    };
  };
}
