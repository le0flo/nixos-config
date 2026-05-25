{config, pkgs, ...}:

let
  style = import ../gui/style.nix { inherit pkgs; };
in {
  xdg.config.files."swaylock/config".text = ''
    ignore-empty-password
    show-failed-attempts

    indicator-idle-visible
    indicator-radius=100

    clock
    timestr=%H:%M:%S
    datestr=%d %B

    image=${config.xdg.config.directory}/background/wallpaper
    color=${style.colors.background}
  '';
}
