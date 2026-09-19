{config, customLib, lib, pkgs, ...}:

let
  inherit (builtins)
    readFile
    replaceStrings;

  inherit (customLib.opts)
    mkBoolOption
    mkPkgsOption;

  inherit (lib)
    getBin
    makeSearchPath
    mkIf;

  cfg = config.otis.gui.plasma-bigscreen;
  kdePackages = with pkgs.kdePackages; [
    breeze
    breeze-icons
    kactivitymanagerd
    kdeconnect-kde
    kwin
    plasma-bigscreen
    plasma-nm
    plasma-pa
    plasma-workspace
    powerdevil
    qqc2-breeze-style
  ];

  sessionScript = pkgs.writeShellScriptBin
    "plasma-bigscreen-session"
    (replaceStrings [
      "*qmlPath*"
      "*kdePath*"
      "*plasma-bigscreen*"
      "*dbus*"
      "*kactivitymanagerd*"
      "*wrapperDir*"
      "*plasma-workspace*"
    ] [
      "${makeSearchPath "lib/qt-6/qml" kdePackages}"
      "${makeSearchPath "share" kdePackages}"
      "${pkgs.kdePackages.plasma-bigscreen}"
      "${pkgs.dbus}"
      "${pkgs.kdePackages.kactivitymanagerd}"
      "${config.security.wrapperDir}"
      "${pkgs.kdePackages.plasma-workspace}"
    ] (readFile ./start.sh));
in {
  options.otis.gui.plasma-bigscreen = {
    enable = mkBoolOption "Plasma Bigscreen graphical session" false;
    extraPackages = mkPkgsOption "Additional packages" [];
  };

  config = mkIf cfg.enable {
    environment = {
      shellAliases."start-plasma-bigscreen" = "${sessionScript}/bin/plasma-bigscreen-session";
      systemPackages = [ sessionScript ] ++ kdePackages ++ cfg.extraPackages;
    };

    security.wrappers."kwin_wayland" = {
      owner = "root";
      group = "root";
      capabilities = "cap_sys_nice+ep";
      source = "${getBin pkgs.kdePackages.kwin}/bin/kwin_wayland";
    };

    xdg.portal.configPackages = [ pkgs.kdePackages.plasma-bigscreen ];
  };
}
