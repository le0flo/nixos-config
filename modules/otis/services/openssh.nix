{config, lib, ...}:

let
  inherit (lib)
    mkEnableOption
    mkIf;

  openssh = config.otis.services.openssh;
in {
  options.otis.services.openssh.enable = mkEnableOption "OpenSSH server";
  
  config = {
    networking.firewall.allowedTCPPorts = mkIf openssh.enable [ 22 ];

    services.openssh = {
      enable = openssh.enable;

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
