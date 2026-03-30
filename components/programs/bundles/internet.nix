{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    dig

    wireguard-tools
    openssh
    rsync
    kubectl
  ];
}
