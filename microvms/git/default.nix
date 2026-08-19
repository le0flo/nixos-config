{microvm, ...}:

{
  microvm = {
    shares = [];

    forwardPorts = [
      {
        from = "host";
        host.port = 11000;
        guest.port = 11000;
      }
      {
        from = "host";
        host.port = 11001;
        guest.port = 11001;
      }
    ];
  };

  services = {
    cgit = {
      enable = true;
    };

    openssh = {
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
