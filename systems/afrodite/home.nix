{...}:

{
  imports = [
    ../../components/programs/configs/fastfetch.nix
    ../../components/programs/configs/git.nix
    ../../components/programs/configs/tmux.nix
  ];

  home = {
    username = "leo";
    homeDirectory = "/home/leo";

    stateVersion = "26.05";
  };
}
