{...}: {
  imports = [
    ./gui
    ./programs
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  # Version
  home.stateVersion = "25.05";
}
