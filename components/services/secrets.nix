{pkgs, ...}:

{
  environment.systemPackages = with pkgs; [ oo7 ];

  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [ oo7-server ];
    };

    gnome.gnome-keyring.enable = false;
  };

  systemd.user.services.oo7-daemon = {
    description = "Secret service (oo7)";
    aliases = [ "dbus-org.freedesktop.secrets.service" ];

    serviceConfig = {
      ExecStart = "${pkgs.oo7-server}/libexec/oo7-daemon";
      Restart = "on-failure";
    };
  };

  xdg.portal.extraPortals = with pkgs; [ oo7-portal ];
}
