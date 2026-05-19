{...}:

{
  imports = [
    ../../components/programs/bash.nix

    ../../components/programs/base.nix
    ../../components/programs/internet.nix
  ];

  virtualisation.docker.enable = true;
}
