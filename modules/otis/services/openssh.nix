{config, customLib, lib, ...}:

let
  inherit (customLib.opts) mkBoolOption;

  inherit (lib) mkIf;

  cfg = config.otis.services.openssh;
in {
  options.otis.services.openssh.enable = mkBoolOption "OpenSSH server" false;
  
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 22 ];

    services.openssh = {
      enable = true;

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
