{pkgs, ...}:

{
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
      "docker"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [ ];
  };

  hjem.users."leo" = {
    directory = "/home/leo";
    clobberFiles = true;

    imports = [
      ../../configs/fastfetch.nix
      ../../configs/git.nix
      ../../configs/tmux.nix
    ];
  };
}
