{pkgs, ...}:

{
  users.users."leo" = {
    isNormalUser = true;
    shell = pkgs.bash;

    extraGroups = [
      "docker"
      "wheel"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAokSVn78uTLEMp73AkLVA2q6+U+IPtqaeTc/HKGIFsV leo@hermes"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWsnFie3ktqVVpKf5MFQPaOpLd+O21rWzdyFX0Lavhy leo@afrodite"
    ];
  };

  hjem.users."leo" = {
    directory = "/home/leo";
    clobberFiles = true;

    imports = [
      ../../configs/fastfetch.nix
      ../../configs/git.nix
      ../../configs/tmux.nix
    ];
  };
}
