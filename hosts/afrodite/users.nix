{pkgs, ...}:

{
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
      "docker"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBAvs2K5ALiCxqylJ22zpMOXXGAaavoiXvZa1LuTq8Gx leo@hermes"
    ];
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
