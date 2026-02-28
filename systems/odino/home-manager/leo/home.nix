{...}: {
  imports = [
    ./programs.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";
  };

  # Version
  home.stateVersion = "25.05";
}
