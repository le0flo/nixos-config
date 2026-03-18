{...}: {
  imports = [
    ../../components/services/openssh.nix
    ../../components/services/caddy.nix
  ];

  # Custom modules
  openssh.enable = true;
  caddy.enable = true;
}
