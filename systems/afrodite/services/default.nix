{...}: {
  imports = [
    ../../../components/services/openssh.nix

    ./bind.nix
    ./caddy.nix
    ./k8s-master.nix
  ];
}
