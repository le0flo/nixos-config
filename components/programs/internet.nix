{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    dig

    wireguard-tools
    openssl
    openssh
    rsync
  ];
}
