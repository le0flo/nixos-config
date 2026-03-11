{inputs, pkgs, ...}: {
  imports = [
    ../../../components/programs/git.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    ascii file fastfetch eza btop dysk
    openssh rsync wireguard-tools dig
    tmux vim

    # Home manager
    inputs.home-manager.packages.${stdenv.hostPlatform.system}.home-manager
  ];

  # Docker
  virtualisation.docker.enable = true;
  users.extraGroups."docker".members = [ "leo" ];

  # Custom modules
  git.enable = true;
}
