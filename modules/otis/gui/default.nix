{config, customLib, lib, pkgs, ...}:

let
  inherit (customLib.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib) mkIf;

  cfg = config.otis.gui;
in {
  imports = [
    ./hyprland
    ./windowmaker

    ./style.nix
  ];

  options.otis.gui = {
    enable = mkBoolOption "Enable gui" false;
    extraFonts = mkPkgsOption "Additional fonts" [];
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      brightnessctl
      libnotify
      playerctl
      wl-clipboard
      xclip
    ];

    fonts.packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      nerd-fonts.comic-shanns-mono
      nerd-fonts.iosevka
    ] ++ cfg.extraFonts;

    hardware.graphics.enable = true;

    programs.uwsm.enable = true;

    services = {
      dbus.enable = true;
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
      libinput.enable = true;
      tumbler.enable = true;

      xserver = {
        enable = true;

        desktopManager.xterm.enable = false;
        displayManager = {
          lightdm.enable = false;
          startx.enable = true;
        };

        deviceSection = ''
        Option "TearFree" "true"
        Option "DRI" "3"
        '';

        videoDrivers = [ "modesetting" ];

        xkb.layout = "it";
      };
    };

    xdg = {
      icons.enable = true;
      autostart.enable = true;

      portal = {
        enable = true;
        xdgOpenUsePortal = true;
      };
    };
  };
}
