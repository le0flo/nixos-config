{...}: {
  imports = [
    ../../components/programs/bash.nix

    ../../components/programs/base.nix
    ../../components/programs/internet.nix
  ];

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups."docker".members = [ "leo" ];
}
