{config, customLib, lib, ...}:

let
  inherit (config.otis.services) fail2ban;

  inherit (customLib.opts)
    mkBoolOption
    mkStrOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.mumble;
in {
  options.otis.services.mumble = {
    enable = mkBoolOption "Mumble server" false;
    domain = mkStrOption "The server's domain" "example.com";
    name = mkStrOption "The server's name" "Mumble server";
    welcome = mkStrOption "The welcome message" "<h1>Welcome</h1>";
    environmentFile = mkStrOption "Environment file" "/etc/mumble/environment";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 64738 ];
      allowedUDPPorts = [ 64738 ];
    };

    services = {
      murmur = {
        inherit (cfg) environmentFile;

        enable = true;
        bandwidth = 128000;
        users = 50;

        registerHostname = "mumble.${cfg.domain}";
        registerUrl = "https://${cfg.domain}";
        registerName = cfg.name;
        welcometext = cfg.welcome;

        tls.useACMEHost = cfg.domain;

        password = "$MURMURD_PASSWORD";
        registerPassword = "$MURMURD_REGISTER_PASSWORD";
      };

      fail2ban.jails = mkIf fail2ban.enable {
        "murmur".settings = {
          enabled = true;
          action = ''iptables[type=oneport, port="64738", protocol=tcp]'';
          filter = "murmur";
          backend = "systemd";
        };
      };
    };

    users.groups."public-acme".members = [ config.services.murmur.user ];
  };
}
