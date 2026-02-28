{...}: {
  imports = [
    ../../../components/services/openssh.nix
  ];

  # Custom
  openssh.enable = true;
}
