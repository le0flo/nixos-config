{...}: {
  imports = [
    ../../components/programs/base.nix
    ../../components/programs/internet.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups."docker".members = [ "leo" ];
}
