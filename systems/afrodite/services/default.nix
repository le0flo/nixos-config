{...}: {
  imports = [
    ../../../components/services/openssh.nix
    ../../../components/services/k8s/master.nix

    ./bind.nix
    ./caddy.nix
  ];
}
