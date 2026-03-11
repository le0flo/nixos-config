{...}: {
  imports = [
    ../../../components/services/openssh.nix
  ];

  # Custom modules
  openssh.enable = true;
}
