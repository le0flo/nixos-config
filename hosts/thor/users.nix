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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDG5j5kM8yANb6RGeFLGFJI8u62TBH01LgpN9jVmEALT leo@hermes"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVH95IieMMZ2R383n4+414Yu1T6NjmWYoUx1QsjTdOL leo@afrodite"
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
