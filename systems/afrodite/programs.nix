{...}:

{
  imports = [
    ../../programs/cli/bash.nix
    ../../programs/cli/base.nix
    ../../programs/cli/internet.nix
  ];

  virtualisation.docker.enable = true;
}
