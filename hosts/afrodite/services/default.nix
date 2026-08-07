{...}:

{
  imports = [
    ../../../services/openssh.nix
    ../../../k3s/server.nix

    ./acme.nix
    ./bind.nix
    ./nginx.nix
  ];
}
