{...}: {
  imports = [
    ../../components/programs/bundles/cli.nix
    ../../components/programs/bundles/internet.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups."docker".members = [ "leo" ];
}
