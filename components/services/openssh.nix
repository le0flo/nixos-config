{lib, config, ...}: {
  options.openssh.enable = lib.mkEnableOption "OpenSSH server";

  config = lib.mkIf config.openssh.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        PrintMotd = false;
      };
    };
  };
}
