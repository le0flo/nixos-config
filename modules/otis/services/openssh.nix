{config, customLibs, lib, ...}:

let
  inherit (customLibs.otis.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.openssh;
in {
  options.otis.services.openssh.enable = mkBoolOption "OpenSSH server" false;
  
  config = {
    networking.firewall.allowedTCPPorts = mkIf cfg.enable [ 22 ];

    services.openssh = {
      inherit (cfg) enable;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        PrintMotd = false;
      };

      extraConfig = ''
      Match user git
        AllowTcpForwarding no
        AllowAgentForwarding no
        PasswordAuthentication no
        PermitTTY no
        X11Forwarding no
      '';
    };
  };
}
