{pkgs, ...}:

{
  imports = [
    ../../programs/cli/bash.nix
    ../../programs/cli/base.nix
    ../../programs/cli/internet.nix
    ../../programs/cli/external.nix
    ../../programs/cli/appimage.nix

    ../../programs/graphical/terminal.nix
    ../../programs/graphical/privacy.nix
    ../../programs/graphical/internet.nix
    ../../programs/graphical/dev.nix
    ../../programs/graphical/office.nix
    ../../programs/graphical/media.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    iwgtk
    openfortivpn
    opencode
    kubectl
    kubelogin
    azure-cli
    prismlauncher
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
}
