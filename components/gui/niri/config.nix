{...}:

{
  xdg = {
    configFile."niri/config.kdl".text = builtins.readFile ./config.kdl;

    mimeApps = {
      enable = true;
      defaultApplications."inode/directory" = [ "thunar.desktop" ];
    };
  };
}
