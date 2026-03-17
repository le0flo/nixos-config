{modulesPath, pkgs, ...} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjRcsulH/b/fVyj+YQi3YchW6wLiWvpgiM+iz4tokSD leo@hermes"
  ] ++ (args.extraPublicKeys or []);

  environment.systemPackages = with pkgs; [ curl gitMinimal ];

  system.stateVersion = "25.05";
}
