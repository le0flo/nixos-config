{...}: {
  imports = [
    ../../components/services/openssh.nix
    ../../components/services/caddy.nix
    ../../components/services/bind.nix
  ];

  # Custom modules
  openssh.enable = true;
  caddy.enable = true;
  bind.enable = true;
}
