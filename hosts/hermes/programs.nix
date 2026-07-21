{pkgs, ...}:

{
  imports = [
    ../../programs/cli/archive.nix
    ../../programs/cli/base.nix
    ../../programs/cli/bash.nix
    ../../programs/cli/dev.nix
    ../../programs/cli/external.nix
    ../../programs/cli/internet.nix
    ../../programs/cli/media.nix
    ../../programs/cli/office.nix
    
    ../../programs/gui/dev.nix
    ../../programs/gui/internet.nix
    ../../programs/gui/media.nix
    ../../programs/gui/office.nix
    ../../programs/gui/privacy.nix
    ../../programs/gui/style.nix
  ];

  environment.systemPackages = with pkgs; [
    iwgtk
    discord

    openfortivpn
    opencode
    kubectl
    kubelogin
    azure-cli
    kubernetes-helm
    gh
    freetds
  ];

  nixpkgs.config.allowUnfree = true;
}
